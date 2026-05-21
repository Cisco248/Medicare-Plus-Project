from abc import abstractmethod

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


class DatabaseConnection:
    def __init__(self, url: str = ""):
        self.engine = None
        self.session = None
        self.url = url

    @abstractmethod
    def _connect(self, url: str):

        if not self.url:
            raise ValueError("Database URL is not Provided")
        self.engine = create_engine(url, echo=False)
        self.session = sessionmaker(autocommit=False, autoflush=False, bind=self.engine)
        return self.session

    @abstractmethod
    def _close(self) -> str:
        if self.session:
            self.session.close_all()
            return "Database connection closed successfully."
        return "No active database connection to close."

    def set_db(self):
        local_session = self._connect(url=self.url)
        try:
            yield local_session
        finally:
            self._close()
