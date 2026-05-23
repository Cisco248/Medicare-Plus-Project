from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


class DatabaseConnection:
    def __init__(self, url: str = ""):
        if not url:
            raise ValueError("Database URL is not Provided")
        self.url = url
        self.engine = create_engine(url, echo=False, pool_pre_ping=True)
        self.SessionLocal = sessionmaker(
            autocommit=False, autoflush=False, bind=self.engine
        )

    def set_db(self):
        session = self.SessionLocal()
        try:
            yield session
        finally:
            session.close()
