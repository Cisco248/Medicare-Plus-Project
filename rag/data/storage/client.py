<<<<<<< Updated upstream
import chromadb
from langchain_chroma import Chroma
from core import RAGSettings

settings = RAGSettings()


class ChromaClient:
    def __init__(self) -> None:
        self.client = chromadb.HttpClient(
            host=settings.CHROMA_HOST,
            port=settings.CHROMA_PORT,
        )

    def build(self):
        try:
            if settings.CHROMA_HOST:
                return Chroma(
                    client=self.client,
                    collection_name=settings.COLLECTION_NAME,
                )
            else:
                return Chroma(
                    persist_directory="./chroma_db",
                    collection_name=settings.COLLECTION_NAME,
                )
        except:
            raise Exception("Cannot Connect with Database")

    def health(self):
        result = self.client.heartbeat()
        version = self.client.get_version()

        if (result and version) != None:
            return True
        else:
            return False
=======
import chromadb
from langchain_chroma import Chroma
from core import RAGSettings

settings = RAGSettings()


class ChromaClient:
    def __init__(self) -> None:
        self.client = chromadb.HttpClient(
            host=settings.CHROMA_HOST,
            port=settings.CHROMA_PORT,
        )

    def build(self):
        try:
            if settings.CHROMA_HOST:
                return Chroma(
                    client=self.client,
                    collection_name=settings.COLLECTION_NAME,
                )
            else:
                return Chroma(
                    persist_directory="./chroma_db",
                    collection_name=settings.COLLECTION_NAME,
                )
        except:
            raise Exception("Cannot Connect with Database")

    def health(self):
        result = self.client.heartbeat()
        version = self.client.get_version()

        if (result and version) != None:
            return True
        else:
            return False
>>>>>>> Stashed changes
