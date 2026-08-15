from dataclasses import dataclass
from threading import Lock

import tiktoken
from langchain_core.documents import Document


@dataclass(frozen=True)
class BudgetedContext:
    text: str
    token_count: int
    document_count: int


class TokenBudget:
    def __init__(
        self,
        model: str,
        max_request_tokens: int,
        max_context_tokens: int,
    ) -> None:
        self.max_request_tokens = max_request_tokens
        self.max_context_tokens = max_context_tokens
        try:
            self._encoding = tiktoken.encoding_for_model(model)
        except KeyError:
            self._encoding = tiktoken.get_encoding("cl100k_base")

    def count(self, text: str) -> int:
        return len(self._encoding.encode(text))

    def validate_question(self, question: str) -> int:
        token_count = self.count(question)
        if token_count > self.max_request_tokens:
            raise ValueError(
                f"Question exceeds the {self.max_request_tokens}-token request budget."
            )
        return token_count

    def build_context(self, documents: list[Document]) -> BudgetedContext:
        selected: list[str] = []
        used_tokens = 0

        for document in documents:
            source = document.metadata.get("source", "unknown")
            page = document.metadata.get("page")
            label = f"[Source: {source}"
            if page is not None:
                label += f", page {int(page) + 1}"
            label += "]"
            block = f"{label}\n{document.page_content.strip()}"
            block_tokens = self.count(block)
            remaining = self.max_context_tokens - used_tokens
            if remaining <= 0:
                break
            if block_tokens > remaining:
                encoded = self._encoding.encode(block)
                block = self._encoding.decode(encoded[:remaining]).strip()
                block_tokens = self.count(block)
            if block:
                selected.append(block)
                used_tokens += block_tokens

        return BudgetedContext(
            text="\n\n".join(selected),
            token_count=used_tokens,
            document_count=len(selected),
        )


class UsageTracker:
    def __init__(self) -> None:
        self._lock = Lock()
        self._total_input = 0
        self._total_output = 0
        self._requests = 0
        self._cache_hits = 0

    def record(self, input_tokens: int, output_tokens: int) -> None:
        with self._lock:
            self._total_input += max(0, input_tokens)
            self._total_output += max(0, output_tokens)
            self._requests += 1

    def record_cache_hit(self) -> None:
        with self._lock:
            self._cache_hits += 1

    def snapshot(self) -> dict[str, int]:
        with self._lock:
            return {
                "total_input_tokens": self._total_input,
                "total_output_tokens": self._total_output,
                "llm_requests": self._requests,
                "cache_hits": self._cache_hits,
            }
