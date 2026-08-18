import re

_STOP_WORDS = {
    "a",
    "an",
    "and",
    "are",
    "as",
    "at",
    "be",
    "by",
    "for",
    "from",
    "how",
    "in",
    "is",
    "it",
    "of",
    "on",
    "or",
    "that",
    "the",
    "this",
    "to",
    "was",
    "what",
    "when",
    "where",
    "which",
    "who",
    "why",
    "with",
}


class QueryProcessor:

    @staticmethod
    def tokens(text: str) -> set[str]:
        return {
            token
            for token in re.findall(r"[a-z0-9]+", text.lower())
            if len(token) > 1 and token not in _STOP_WORDS
        }
