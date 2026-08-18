from typing import Any
from langchain_core.documents import Document


class MetadataFilter:

    @staticmethod
    def matches(
        document: Document,
        metadata_filter: dict[str, Any] | None = None,
    ) -> bool:

        if not metadata_filter:
            return True

        return all(
            document.metadata.get(key) == value
            for key, value in metadata_filter.items()
        )

    def filter(
        self,
        documents: list[Document],
        metadata_filter: dict[str, Any] | None = None,
    ) -> list[Document]:

        return [
            document
            for document in documents
            if self.matches(document, metadata_filter)
        ]
