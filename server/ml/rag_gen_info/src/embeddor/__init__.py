from typing import List
from langchain_huggingface.embeddings import HuggingFaceEmbeddings
from langchain_core.documents import Document
from constants import Settings

settings = Settings()


class DocumentEmbeddor:
    def __init__(self) -> None:
        self.embedding_model = HuggingFaceEmbeddings(
            model_name=settings.EMBEDDING_MODEL_NAME,
            encode_kwargs={"normalize_embeddings": False},
            model_kwargs={"device": "cpu"},
        )

    def init_embeddor(self):
        return self.embedding_model

    def encode_document(self, document: List[Document]):
        for i, doc in enumerate(document):
            return self.embedding_model.embed_documents([doc.page_content])
