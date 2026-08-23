import os

os.environ.setdefault("MYSQL_HOST", "localhost")
os.environ.setdefault("MYSQL_PORT", "3306")
os.environ.setdefault("MYSQL_USER", "root")
os.environ.setdefault("MYSQL_PASSWORD", "password")
os.environ.setdefault("MYSQL_DATABASE", "medicare_test")
os.environ.setdefault("JWT_SECRET_KEY", "test-secret")
os.environ.setdefault("PORT", "8080")
os.environ.setdefault("CORS_ORIGINS", "*")

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from core import get_db
from data import BASE
from main import app


engine = create_engine(
    "sqlite://",
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSession = sessionmaker(autocommit=False, autoflush=False, bind=engine)
BASE.metadata.create_all(bind=engine)


def _override_db():
    session = TestingSession()
    try:
        yield session
    finally:
        session.close()


app.dependency_overrides[get_db] = _override_db


@pytest.fixture
def client(monkeypatch):
    monkeypatch.setattr("main.initialize_database", lambda: None)
    BASE.metadata.drop_all(bind=engine)
    BASE.metadata.create_all(bind=engine)
    return TestClient(app, raise_server_exceptions=False)


@pytest.fixture
def auth_headers(client: TestClient):
    client.post(
        "/api/register",
        json={
            "name": "Test Patient",
            "email": "patient@example.com",
            "mobnum": "0770000000",
            "password": "secret123",
        },
    )
    login = client.post(
        "/api/login",
        json={"email": "patient@example.com", "password": "secret123"},
    )
    token = login.json()["token"]
    user_id = login.json()["id"]
    return {"X-Auth-Token": token}, user_id
