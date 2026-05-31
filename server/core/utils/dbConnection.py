from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from data.models.base import BASE

engine = create_engine(
    "mysql+pymysql://root:root123@127.0.0.1:3306/medicare_plus",
    echo=False,
    pool_pre_ping=True,
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

BASE.metadata.create_all(bind=engine, checkfirst=True)


def get_db():
    db = SessionLocal()
    if db is None:
        raise Exception("Database not initialized.")
    try:
        yield db
    finally:
        db.close()
        engine.dispose()
