import logging
from langchain_openai import OpenAIEmbeddings
from pydantic import SecretStr
from core.configs.configuration import RAGSettings

logger = logging.getLogger(__name__)
settings = RAGSettings()


class DocumentEmbeddor:
    def __init__(self) -> None:
        self.model: OpenAIEmbeddings | None = None

    def load(self) -> OpenAIEmbeddings:
        if not self.model:
            if not settings.OPENAI_API_KEY:
                raise ValueError("OPENAI_API_KEY is required to build the RAG index.")
            self.model = OpenAIEmbeddings(
                model=settings.EMBEDDING_MODEL_NAME,
                api_key=SecretStr(settings.OPENAI_API_KEY),
            )
            logger.info(
                "Initialized OpenAI embedding model %s", settings.EMBEDDING_MODEL_NAME
            )
        return self.model
