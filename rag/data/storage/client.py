import chromadb
from langchain_chroma import Chroma
from langchain_core.embeddings import Embeddings
from core.configs.configuration import RAGSettings

settings = RAGSettings()


class ChromaClient:
    def __init__(self, embedding_function: Embeddings | None = None) -> None:
        self.embedding_function = embedding_function
        self.client = None
        if settings.CHROMA_HOST:
            self.client = chromadb.HttpClient(
                host=settings.CHROMA_HOST,
                port=settings.CHROMA_PORT,
            )

    def build(self) -> Chroma:
        try:
            if self.client is not None:
                return Chroma(
                    client=self.client,
                    collection_name=settings.COLLECTION_NAME,
                    embedding_function=self.embedding_function,
                    collection_metadata={"hnsw:space": "cosine"},
                )
            settings.VECTOR_DB_DIR.mkdir(parents=True, exist_ok=True)
            return Chroma(
                persist_directory=str(settings.VECTOR_DB_DIR),
                collection_name=settings.COLLECTION_NAME,
                embedding_function=self.embedding_function,
                collection_metadata={"hnsw:space": "cosine"},
            )
        except Exception as exc:
            raise ConnectionError("Cannot connect to the Chroma database.") from exc

    def health(self) -> bool:
        try:
            if self.client is not None:
                return bool(self.client.heartbeat() and self.client.get_version())
            self.build().get(limit=1, include=[])
            return True
        except Exception:
            return False
