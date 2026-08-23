from langchain.embeddings import Embeddings
from langchain_chroma import Chroma

from core.configs.configuration import RAGSettings
from data.storage.local_client import LocalClient
from data.storage.remote_client import RemoteClient

settings = RAGSettings()


class ClientFactory:
    def __init__(self, embeddings: Embeddings | None = None) -> None:
        self.client = None
        self.embeddings = embeddings

    def manager(self) -> Chroma:
        if settings.CHROMA_HOST:
            self.client = RemoteClient(self.embeddings).build()
            return self.client
        else:
            self.client = LocalClient(self.embeddings).build()
            return self.client

    def health_manager(self):
        if settings.CHROMA_HOST:
            self.client = RemoteClient(self.embeddings).health()
            return self.client
        else:
            self.client = LocalClient(self.embeddings).health()
            return self.client
