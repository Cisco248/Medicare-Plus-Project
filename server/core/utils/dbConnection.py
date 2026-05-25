from contextlib import contextmanager
from typing import Optional
from sqlalchemy import create_engine
from sqlalchemy.engine import Engine
from sqlalchemy.orm import declarative_base, sessionmaker

from core.constants.response import _ResponseCode, _ResponseStatus, ResponseMessage


class DatabaseConnection:
    def __init__(self, url: str) -> None:
        self.url = url.strip()
        if not self.url:
            raise ValueError("Database URL is not provided.")

        self.engine: Optional[Engine] = None
        self.SessionLocal: Optional[sessionmaker] = None

    def init_db(self, base=declarative_base()):
        try:
            self.engine = create_engine(self.url, echo=False, pool_pre_ping=True)
            self.SessionLocal = sessionmaker(
                autocommit=False, autoflush=False, bind=self.engine
            )
            base.metadata.create_all(
                bind=self.engine,
                exist=True,
            )

            return ResponseMessage(
                status=_ResponseStatus.SUCCESS,
                code=_ResponseCode.SUCCESS,
                message="Database connection established successfully.",
            )

        except Exception as e:
            return ResponseMessage(
                status=_ResponseStatus.ERROR,
                code=_ResponseCode.INTERNAL_SERVER_ERROR,
                message=f"Failed to connect to the database: {e}",
            )

    def close_db(self):
        try:
            if self.engine is not None:
                self.engine.dispose()
            return ResponseMessage(
                status=_ResponseStatus.SUCCESS,
                code=_ResponseCode.SUCCESS,
                message="Database connection closed successfully.",
            )

        except Exception as e:
            return ResponseMessage(
                status=_ResponseStatus.ERROR,
                code=_ResponseCode.INTERNAL_SERVER_ERROR,
                message=f"Failed to close the database connection: {e}",
            )

    def get_db(self):
        if self.SessionLocal is None:
            raise Exception("Database not initialized.")
        db = self.SessionLocal()
        try:
            yield db

        finally:
            db.close()
