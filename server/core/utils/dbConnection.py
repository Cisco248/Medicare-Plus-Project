from dataclasses import dataclass
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from data.models.base import BASE
from core.configs.server_configuration import ServerSettings
from core.constants.values.exception import DBConnnectionException

setting = ServerSettings()


@dataclass
class DBConnection:
    ENGINE = create_engine(
        f"mysql+pymysql://{setting.DB_USER}:{setting.DB_PASSWORD}@{setting.DB_HOST}:{setting.DB_PORT}/{setting.DB_NAME}",
        echo=setting.ECO,
        pool_pre_ping=setting.Pool_Pre_Ping,
    )
    SESSION_LOACAL = sessionmaker(autocommit=False, autoflush=False, bind=ENGINE)
    BASE.metadata.create_all(bind=ENGINE, checkfirst=True)


def get_db():
    db = DBConnection()
    db_conn = db.SESSION_LOACAL()
    if db_conn is None:
        raise ConnectionError(DBConnnectionException.NOT_FOUND)
    try:
        yield db_conn
    finally:
        db_conn.close()
        db.ENGINE.dispose()
