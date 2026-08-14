import os
import uuid

from fastapi import HTTPException, UploadFile
from sqlalchemy import text

from core import DocumentString, ServerSettings

setting = ServerSettings()

ALLOWED_EXTENSIONS = {"pdf", "jpg", "jpeg", "png"}
ALLOWED_STATUSES = {"uploaded", "processing", "reviewed", "rejected"}
MAX_FILE_SIZE_BYTES = 10 * 1024 * 1024

MEDIA_TYPES = {
    "pdf": "application/pdf",
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "png": "image/png",
}


class DocumentMiddleware:
    @staticmethod
    def ensure_optional_columns(engine) -> None:
        """Adds issuer/hospital columns on existing databases created before those fields."""
        statements = (
            "ALTER TABLE document ADD COLUMN issuer VARCHAR(100) NULL",
            "ALTER TABLE document ADD COLUMN hospital VARCHAR(100) NULL",
        )
        with engine.connect() as connection:
            for statement in statements:
                try:
                    connection.execute(text(statement))
                    connection.commit()
                except Exception:
                    connection.rollback()

    @staticmethod
    def validate_extension(file: UploadFile) -> str:
        name = file.filename or ""
        extension = name.rsplit(".", 1)[-1].lower() if "." in name else ""
        if extension not in ALLOWED_EXTENSIONS:
            raise HTTPException(400, DocumentString.INVALID_FILE_TYPE.value)
        return extension

    @staticmethod
    async def save_file(file: UploadFile, extension: str) -> str:
        content = await file.read()
        if not content:
            raise HTTPException(400, DocumentString.FILE_EMPTY.value)
        if len(content) > MAX_FILE_SIZE_BYTES:
            raise HTTPException(400, DocumentString.FILE_TOO_LARGE.value)

        os.makedirs(setting.DOCUMENT_STORAGE_PATH, exist_ok=True)
        stored_name = f"{uuid.uuid4().hex}.{extension}"
        file_path = os.path.join(setting.DOCUMENT_STORAGE_PATH, stored_name)
        with open(file_path, "wb") as output:
            output.write(content)
        return file_path

    @staticmethod
    def delete_file(file_path: str) -> None:
        try:
            if os.path.exists(file_path):
                os.remove(file_path)
        except OSError:
            # The database record is the source of truth; a leftover file on
            # disk must not block deleting the document.
            pass

    @staticmethod
    def validate_status(status: str) -> str:
        value = status.strip().lower()
        if value not in ALLOWED_STATUSES:
            raise HTTPException(400, DocumentString.INVALID_STATUS.value)
        return value

    @staticmethod
    def media_type(file_type: str) -> str:
        return MEDIA_TYPES.get(file_type.lower(), "application/octet-stream")
