import logging
from typing import List
from langchain_openai import OpenAIEmbeddings
from langchain_core.documents import Document
from pydantic import SecretStr
from core import RAGSettings

logger = logging.getLogger(__name__)
settings = RAGSettings()


class DocumentEmbeddor:
    @staticmethod
    def load_embedding(document: List[Document]):
        # if not settings.EMBEDDING_PATH.exists():
        #     settings.EMBEDDING_PATH.mkdir(parents=True, exist_ok=True)
        model = OpenAIEmbeddings(
            model=settings.EMBEDDING_MODEL_NAME,
            api_key=SecretStr(settings.OPENAI_API_KEY),
        )
        # joblib.dump(model, f"{settings.EMBEDDING_PATH}/embedding_model.pkl")
        # model: HuggingFaceEmbeddings = joblib.load(
        #     f"{settings.EMBEDDING_PATH}/embedding_model.pkl"
        # )

        logger.info("<--- Text Embedding Started --->")
        for i, doc in enumerate(document):
            return model.embed_documents([doc.page_content])
