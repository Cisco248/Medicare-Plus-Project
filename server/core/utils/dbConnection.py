from dataclasses import dataclass
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from core.configs.server_configuration import ServerSettings
from core.constants.values.exception import DBConnnectionException

setting = ServerSettings()


@dataclass
class DBConnection:

    if setting.DB_HOST.startswith("/cloudsql/"):
        DATABASE_URL = (
            f"mysql+pymysql://"
            f"{setting.DB_USER}:"
            f"{setting.DB_PASSWORD}@"
            f"/{setting.DB_NAME}"
            f"?unix_socket={setting.DB_HOST}"
        )
    else:
        DATABASE_URL = (
            f"mysql+pymysql://"
            f"{setting.DB_USER}:"
            f"{setting.DB_PASSWORD}@"
            f"{setting.DB_HOST}:"
            f"{setting.DB_PORT}/"
            f"{setting.DB_NAME}"
        )

    ENGINE = create_engine(
        DATABASE_URL, echo=setting.ECO, pool_pre_ping=setting.Pool_Pre_Ping
    )
    SESSION_LOACAL = sessionmaker(autocommit=False, autoflush=False, bind=ENGINE)


def get_db():
    db = DBConnection()
    db_conn = db.SESSION_LOACAL()
    if db_conn is None:
        raise ConnectionError(DBConnnectionException.NOT_FOUND)
    try:
        yield db_conn
    finally:
        db_conn.close()


# mysql+pymysql://medicare_app:PASSWORD@localhost/medicare_db?unix_socket=/cloudsql/medicare-plus-506621:europe-west1:medicare-db
