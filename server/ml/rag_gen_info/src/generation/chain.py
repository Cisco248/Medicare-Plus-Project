import logging
import os
from pydantic import SecretStr
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_openai import ChatOpenAI
from constants import Settings
from dotenv import load_dotenv

logger = logging.getLogger(__name__)
load_dotenv()


class RAGChainManager:
    def __init__(self, retriever):
        self.retriever = retriever
        self.llm = ChatOpenAI(
            model=Settings.LLM_MODEL_NAME,
            base_url=Settings.LLM_BASE_URL,
            api_key=SecretStr(Settings.GROQ_API_TOKEN),
        )

    def _format_docs(self, docs):
        return "\n\n".join(doc.page_content for doc in docs)

    def build_chain(self):
        logger.info("Building LCEL RAG chain...")
        return (
            {
                "context": self.retriever | self._format_docs,
                "question": RunnablePassthrough(),
            }
            | ChatPromptTemplate.from_template("""
                You are a medical assistant for informational purposes only.

                STRICT RULES:
                - Return ONLY valid JSON.
                - Do NOT include reasoning, explanation, or hidden steps.
                - Do NOT include markdown or extra text.
                - Output must be machine-readable JSON only.

                JSON FORMAT:
                {
                "answer": "final simple explanation",
                "recommendations": ["point 1", "point 2", "point 3"],
                "caution": "short medical caution message"
                }

                Context:
                {context}

                Question:
                {question}
                """)
            | self.llm
        )
