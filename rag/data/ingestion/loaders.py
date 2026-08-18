import logging
from pathlib import Path
from typing import List
from langchain_core.documents import Document
from langchain_community.document_loaders import (
    TextLoader,
    PyPDFLoader,
    Docx2txtLoader,
    UnstructuredMarkdownLoader,
    UnstructuredURLLoader,
)

logger = logging.getLogger(__name__)


class DocumentLoader:
    def __init__(
        self, documents: List[str] | None = None, urls: List[str] | None = None
    ) -> None:
        self.documents = documents or []
        self.urls = urls or []

    def URLLoader(self) -> List[Document]:
        if not self.urls:
            return []
        logger.info("Loading URLs: %s", self.urls)
        loader = UnstructuredURLLoader(urls=self.urls)
        return loader.load()

    def MDLoader(self, doc: str | None) -> List[Document]:
        if not doc:
            raise ValueError("file not found!")
        loader = UnstructuredMarkdownLoader(doc, mode="all")
        return loader.load()

    def DocxLoader(self, doc: str | None) -> List[Document]:
        if not doc:
            raise ValueError("file not found!")
        loader = Docx2txtLoader(doc)
        return loader.load()

    def PDFLoader(self, doc: str | None) -> List[Document]:
        if not doc:
            raise ValueError("file not found!")
        loader = PyPDFLoader(doc)
        return loader.load()

    def TextLoader(self, doc: str | None) -> List[Document]:
        if not doc:
            raise ValueError("file not found!")
        loader = TextLoader(doc)
        return loader.load()

    def load(self) -> List[Document]:
        logger.info("Loading documents=%s, urls=%s", self.documents, self.urls)
        try:
            if not self.documents and not self.urls:
                raise ValueError("No documents or URLs provided")

            loaded_document: List[Document] = []
            for doc in self.documents:
                extention = Path(doc).suffix.lower()
                if extention == ".md":
                    loaded_document.extend(self.MDLoader(doc))
                elif doc.endswith(".docx"):
                    loaded_document.extend(self.DocxLoader(doc))
                elif doc.endswith(".pdf"):
                    loaded_document.extend(self.PDFLoader(doc))
                elif doc.endswith(".txt"):
                    loaded_document.extend(self.TextLoader(doc))
                else:
                    raise ValueError(f"Unsupported file type: {doc}")

            if self.urls:
                loaded_document.extend(self.URLLoader())
            logger.info("Successfully loaded %d documents", len(loaded_document))
            return loaded_document

        except Exception as e:
            logger.exception(
                "Error loading documents=%s, urls=%s", self.documents, self.urls
            )
            raise
