import html
import logging
import re
from concurrent.futures import ThreadPoolExecutor, as_completed
from html.parser import HTMLParser
from pathlib import Path
from typing import List
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from langchain_core.documents import Document
from langchain_community.document_loaders import (
    TextLoader,
    PyPDFLoader,
    Docx2txtLoader,
)

logger = logging.getLogger(__name__)

_SKIP_NAMES = {"README.md", "SOURCES.md", "VERSION.md", "knowledge_urls.txt"}
_SUPPORTED_SUFFIXES = {".md", ".txt", ".pdf", ".docx"}
_URL_TIMEOUT_SECONDS = 15
_URL_WORKERS = 6
_MIN_URL_CHARS = 200
_USER_AGENT = (
    "MedicarePlusRAG/1.1 (+https://github.com; educational knowledge ingest)"
)


class DocumentLoader:
    def __init__(
        self, documents: List[str] | None = None, urls: List[str] | None = None
    ) -> None:
        self.documents = documents or []
        self.urls = urls or []

    def URLLoader(self) -> List[Document]:
        if not self.urls:
            return []
        logger.info("Loading %d knowledge URLs", len(self.urls))
        loaded_document: List[Document] = []
        with ThreadPoolExecutor(max_workers=_URL_WORKERS) as pool:
            futures = {
                pool.submit(self._load_one_url, url): url for url in self.urls
            }
            for future in as_completed(futures):
                url = futures[future]
                try:
                    documents = future.result()
                except Exception:
                    logger.warning("Skipping knowledge URL %s", url, exc_info=True)
                    continue
                if documents:
                    loaded_document.extend(documents)
        logger.info("Loaded %d documents from knowledge URLs", len(loaded_document))
        return loaded_document

    def _load_one_url(self, url: str) -> List[Document]:
        documents = self._load_url_unstructured(url)
        if not documents:
            documents = self._load_url_html(url)
        for document in documents:
            document.metadata["source"] = url
            document.metadata["url"] = url
        return documents

    def _load_url_unstructured(self, url: str) -> List[Document]:
        try:
            from langchain_community.document_loaders import UnstructuredURLLoader
        except Exception:
            return []
        try:
            loaded = UnstructuredURLLoader(urls=[url]).load()
        except Exception:
            logger.info("Unstructured URL load failed for %s; using HTML fallback", url)
            return []
        return [
            document
            for document in loaded
            if document.page_content and document.page_content.strip()
        ]

    def _load_url_html(self, url: str) -> List[Document]:
        request = Request(url, headers={"User-Agent": _USER_AGENT})
        try:
            with urlopen(request, timeout=_URL_TIMEOUT_SECONDS) as response:
                raw = response.read()
                charset = response.headers.get_content_charset() or "utf-8"
        except HTTPError as exc:
            logger.warning("HTTP %s for knowledge URL %s", exc.code, url)
            return []
        except (URLError, TimeoutError, OSError) as exc:
            logger.warning("HTTP fetch failed for knowledge URL %s: %s", url, exc)
            return []
        html_text = raw.decode(charset, errors="replace")
        text = _html_to_text(html_text)
        if len(text) < _MIN_URL_CHARS:
            logger.warning("Skipping sparse knowledge URL %s", url)
            return []
        return [Document(page_content=text, metadata={"source": url, "url": url})]

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


class _HTMLTextExtractor(HTMLParser):
    _SKIP_TAGS = {"script", "style", "noscript", "svg", "nav", "footer", "header"}

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self._skip_depth = 0
        self._parts: list[str] = []

    def handle_starttag(self, tag: str, attrs) -> None:
        if tag in self._SKIP_TAGS:
            self._skip_depth += 1
        elif tag in {"p", "br", "li", "h1", "h2", "h3", "h4", "tr", "div"}:
            self._parts.append("\n")

    def handle_endtag(self, tag: str) -> None:
        if tag in self._SKIP_TAGS and self._skip_depth:
            self._skip_depth -= 1

    def handle_data(self, data: str) -> None:
        if self._skip_depth:
            return
        text = data.strip()
        if text:
            self._parts.append(text)


def _html_to_text(markup: str) -> str:
    parser = _HTMLTextExtractor()
    parser.feed(markup)
    text = html.unescape(" ".join(parser._parts))
    return re.sub(r"\n{3,}|\s{2,}", lambda match: "\n\n" if "\n" in match.group() else " ", text).strip()
