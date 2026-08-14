import logging
from langchain_openai import OpenAIEmbeddings
from pydantic import SecretStr
from core.configs.configuration import RAGSettings

logger = logging.getLogger(__name__)
settings = RAGSettings()


class DocumentEmbeddor:
    _model: OpenAIEmbeddings | None = None

    @staticmethod
    def load_embedding() -> OpenAIEmbeddings:
        """Return one reusable embedding client.

        Chroma performs document embeddings in batches when new chunks are
        added and performs one query embedding per similarity search.
        """
        if DocumentEmbeddor._model is None:
            if not settings.OPENAI_API_KEY:
                raise ValueError("OPENAI_API_KEY is required to build the RAG index.")
            DocumentEmbeddor._model = OpenAIEmbeddings(
                model=settings.EMBEDDING_MODEL_NAME,
                api_key=SecretStr(settings.OPENAI_API_KEY),
            )
            logger.info(
                "Initialized OpenAI embedding model %s",
                settings.EMBEDDING_MODEL_NAME,
            )
        return DocumentEmbeddor._model
