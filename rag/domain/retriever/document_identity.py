from langchain_core.documents import Document


class DocumentIdentity:

    @staticmethod
    def get(document: Document) -> str:

        return str(
            document.metadata.get("chunk_id")
            or document.metadata.get("id")
            or document.page_content
        )
