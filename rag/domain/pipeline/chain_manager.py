import hashlib
import logging
import time
from collections import OrderedDict
from threading import Lock
from typing import Any

from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.documents import Document
from pydantic import SecretStr

from domain.retriever.query_expander import expand_query
from core.configs.configuration import RAGSettings
from .token_budget import TokenBudget, UsageTracker

logger = logging.getLogger(__name__)
settings = RAGSettings()


class RAGPipeline:
    """Reusable retrieval and generation pipeline with bounded in-memory cache."""

    def __init__(self, retriever: Any | None, index_version: str) -> None:
        self.retriever = retriever
        self.index_version = index_version
        self.ready = retriever is not None
        self._budget = TokenBudget(
            model=settings.LLM_MODEL_NAME,
            max_request_tokens=settings.MAX_REQUEST_TOKENS,
            max_context_tokens=settings.MAX_CONTEXT_TOKENS,
        )
        self._usage = UsageTracker()
        self._cache: OrderedDict[str, tuple[float, str]] = OrderedDict()
        self._cache_lock = Lock()

        self._prompt = ChatPromptTemplate.from_messages(
            [
                (
                    "system",
                    "You are a medical information assistant for MediCare Plus. "
                    "Use the supplied knowledge context as the source of truth. "
                    "If the question includes submitted health values or a model "
                    "prediction, interpret those values using the knowledge context. "
                    "Answer clearly in everyday language. Do not diagnose. Do not "
                    "invent facts, thresholds, medicines, or missing patient values. "
                    "A machine-learning prediction is not a clinical diagnosis. "
                    "This information is educational and does not replace a qualified "
                    "healthcare professional. "
                    "If emergency warning signs are described, tell the user to "
                    "contact local emergency services immediately and do not delay "
                    "for more questions. "
                    "If the knowledge context covers the topic, give a useful "
                    "educational answer even when a single number cannot settle a "
                    "diagnosis. "
                    "Only say \"I don't know based on the available documents\" when "
                    "the topic is genuinely absent from the context.",
                ),
                (
                    "human",
                    "Knowledge context:\n{context}\n\nQuestion:\n{question}",
                ),
            ]
        )
        self._llm = (
            ChatOpenAI(
                model=settings.LLM_MODEL_NAME,
                temperature=settings.LLM_TEMPERATURE,
                max_completion_tokens=settings.MAX_OUTPUT_TOKENS,
                api_key=SecretStr(settings.OPENAI_API_KEY),
            )
            if settings.OPENAI_API_KEY
            else None
        )

    def _cache_key(self, question: str, patient_context: str = "") -> str:
        normalized = " ".join(question.lower().split())
        context_norm = " ".join(patient_context.lower().split())
        return hashlib.sha256(
            f"{self.index_version}\x1f{normalized}\x1f{context_norm}".encode("utf-8")
        ).hexdigest()

    def _get_cached(self, key: str) -> str | None:
        now = time.monotonic()
        with self._cache_lock:
            cached = self._cache.get(key)
            if cached is None:
                return None
            created_at, answer = cached
            if now - created_at > settings.RESPONSE_CACHE_TTL_SECONDS:
                del self._cache[key]
                return None
            self._cache.move_to_end(key)
            self._usage.record_cache_hit()
            return answer

    def _set_cached(self, key: str, answer: str) -> None:
        with self._cache_lock:
            self._cache[key] = (time.monotonic(), answer)
            self._cache.move_to_end(key)
            while len(self._cache) > settings.RESPONSE_CACHE_SIZE:
                self._cache.popitem(last=False)

    def search(
        self,
        question: str,
        metadata_filter: dict[str, Any] | None = None,
        k: int | None = None,
        patient_context: str | None = None,
    ) -> list[Document]:
        question = question.strip()
        if not question:
            raise ValueError("Question cannot be empty.")
        if len(question) > settings.MAX_QUERY_CHARS:
            raise ValueError(
                f"Question exceeds the {settings.MAX_QUERY_CHARS}-character limit."
            )
        self._budget.validate_question(question)
        if self.retriever is None:
            return []
        retrieval_query = expand_query(question, patient_context)
        return self.retriever.search(
            retrieval_query, metadata_filter=metadata_filter, k=k
        )

    def invoke(self, question: str, patient_context: str | None = None) -> str:
        return self._generate(question, self._prompt, patient_context)

    def invoke_health_summary(self, question: str, prompt: ChatPromptTemplate) -> str:
        return self._generate(question, prompt)

    def _generation_question(self, question: str, patient_context: str | None) -> str:
        question = question.strip()
        context = (patient_context or "").strip()
        if not context:
            return question
        return (
            "Submitted health values (dynamic patient data, not from the knowledge "
            f"documents):\n{context}\n\nUser question:\n{question}"
        )

    def _generate(
        self,
        question: str,
        prompt: ChatPromptTemplate,
        patient_context: str | None = None,
    ) -> str:
        documents = self.search(question, patient_context=patient_context)
        if not documents:
            return "I don't know based on the available documents."

        context = self._budget.build_context(documents)
        if not context.text:
            return "I don't know based on the available documents."

        generation_question = self._generation_question(question, patient_context)
        key = self._cache_key(generation_question, patient_context or "")
        cached = self._get_cached(key)
        if cached is not None:
            return cached
        if self._llm is None:
            raise ValueError("OPENAI_API_KEY is required for answer generation.")

        messages = prompt.format_messages(
            context=context.text,
            question=generation_question,
        )
        response = self._llm.invoke(messages)
        answer = str(response.content).strip()

        usage = response.usage_metadata or {}
        input_tokens = int(
            usage.get(
                "input_tokens",
                self._budget.count(context.text)
                + self._budget.count(generation_question),
            )
        )
        output_tokens = int(usage.get("output_tokens", self._budget.count(answer)))
        self._usage.record(input_tokens, output_tokens)
        self._set_cached(key, answer)
        return answer

    def usage_stats(self) -> dict[str, int | str | bool]:
        return {
            **self._usage.snapshot(),
            "model": settings.LLM_MODEL_NAME,
            "index_version": self.index_version,
            "ready": self.ready,
        }


class RAGChainManager:
    @staticmethod
    def build_chain(
        retriever: Any | None,
        index_version: str = "empty",
    ) -> RAGPipeline:
        logger.info("RAG pipeline initialized (index=%s).", index_version)
        return RAGPipeline(retriever=retriever, index_version=index_version)
