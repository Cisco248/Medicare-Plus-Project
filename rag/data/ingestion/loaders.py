import logging
from pathlib import Path
from typing import List

from langchain_core.documents import Document
from langchain_community.document_loaders import (
    TextLoader,
    PyPDFLoader,
    Docx2txtLoader,
    UnstructuredURLLoader,
)

logger = logging.getLogger(__name__)

_SKIP_NAMES = {"README.md", "SOURCES.md", "VERSION.md"}
_SUPPORTED_SUFFIXES = {".md", ".txt", ".pdf", ".docx"}


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
        loader = TextLoader(doc, encoding="utf-8")
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
        loader = TextLoader(doc, encoding="utf-8")
        return loader.load()

    def _expand_paths(self) -> list[tuple[Path, Path]]:
        """Resolve files as (file_path, knowledge_root) pairs."""
        expanded: list[tuple[Path, Path]] = []
        for item in self.documents:
            path = Path(item)
            if path.is_dir():
                for child in sorted(path.rglob("*")):
                    if not child.is_file():
                        continue
                    if child.suffix.lower() not in _SUPPORTED_SUFFIXES:
                        continue
                    if child.name in _SKIP_NAMES:
                        continue
                    expanded.append((child, path))
            elif path.is_file():
                if path.name in _SKIP_NAMES:
                    continue
                if path.suffix.lower() not in _SUPPORTED_SUFFIXES:
                    raise ValueError(f"Unsupported file type: {path}")
                expanded.append((path, path.parent))
            else:
                raise ValueError(f"Path does not exist: {path}")
        return expanded

    def _stamp_source(self, documents: List[Document], file_path: Path, root: Path) -> None:
        try:
            relative = file_path.resolve().relative_to(root.resolve()).as_posix()
        except ValueError:
            relative = file_path.name
        for document in documents:
            document.metadata["source"] = relative

    def load(self) -> List[Document]:
        logger.info("Loading documents=%s, urls=%s", self.documents, self.urls)
        try:
            if not self.documents and not self.urls:
                raise ValueError("No documents or URLs provided")

            loaded_document: List[Document] = []
            for file_path, root in self._expand_paths():
                suffix = file_path.suffix.lower()
                path_str = str(file_path)
                if suffix == ".md":
                    loaded = self.MDLoader(path_str)
                elif suffix == ".docx":
                    loaded = self.DocxLoader(path_str)
                elif suffix == ".pdf":
                    loaded = self.PDFLoader(path_str)
                elif suffix == ".txt":
                    loaded = self.TextLoader(path_str)
                else:
                    raise ValueError(f"Unsupported file type: {file_path}")
                self._stamp_source(loaded, file_path, root)
                loaded_document.extend(loaded)

            if self.urls:
                loaded_document.extend(self.URLLoader())
            logger.info("Successfully loaded %d documents", len(loaded_document))
            return loaded_document

        except Exception:
            logger.exception(
                "Error loading documents=%s, urls=%s", self.documents, self.urls
            )
            raise
