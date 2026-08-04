import chromadb
from langchain_chroma import Chroma
from core import RAGSettings

settings = RAGSettings()


class ChromaClient:
    @staticmethod
    def build():
        if settings.CHROMA_HOST:
            client = chromadb.HttpClient(
                host=settings.CHROMA_HOST, port=settings.CHROMA_PORT
            )
            return Chroma(client=client, collection_name=settings.COLLECTION_NAME)
        else:
            return Chroma(
                persist_directory="./chroma_db",
                collection_name=settings.COLLECTION_NAME,
            )
