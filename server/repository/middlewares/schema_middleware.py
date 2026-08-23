import logging

from sqlalchemy import text

logger = logging.getLogger(__name__)

_USER_COLUMNS = (
    "ALTER TABLE user ADD COLUMN date_of_birth DATE NULL",
    "ALTER TABLE user ADD COLUMN gender VARCHAR(20) NULL",
    "ALTER TABLE user ADD COLUMN height_cm FLOAT NULL",
    "ALTER TABLE user ADD COLUMN weight_kg FLOAT NULL",
    "ALTER TABLE user ADD COLUMN blood_group VARCHAR(8) NULL",
    "ALTER TABLE user ADD COLUMN allergies TEXT NULL",
    "ALTER TABLE user ADD COLUMN clinical_history TEXT NULL",
    "ALTER TABLE user ADD COLUMN emergency_contact VARCHAR(100) NULL",
    "ALTER TABLE user ADD COLUMN emergency_phone VARCHAR(20) NULL",
    "ALTER TABLE user ADD COLUMN address VARCHAR(255) NULL",
    "ALTER TABLE user ADD COLUMN preferred_language VARCHAR(32) NULL",
    "ALTER TABLE user ADD COLUMN medical_notes TEXT NULL",
    "ALTER TABLE user ADD COLUMN created_at DATETIME NULL",
    "ALTER TABLE user ADD COLUMN updated_at DATETIME NULL",
)


class SchemaMiddleware:
    """Adds newly introduced columns to databases created before those fields."""

    @staticmethod
    def ensure_optional_columns(engine) -> None:
        with engine.connect() as connection:
            for statement in _USER_COLUMNS:
                try:
                    connection.execute(text(statement))
                    connection.commit()
                except Exception:
                    connection.rollback()
                    logger.debug("Column already present or ALTER skipped: %s", statement)
