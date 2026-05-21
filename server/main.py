from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine

from core.constants.config import app_name, app_version, debug, cors_origins, DB_URL
from repository.routes.auth_router import AuthRouter
from data.entity.auth.client import ClientAuthEntity  # noqa: F401  (register model)
from data.entity.auth.admin import AuthEntity as AdminAuthEntity  # noqa: F401
from data.models.base import BASE

_engine = create_engine(DB_URL, echo=False)
BASE.metadata.create_all(bind=_engine)

app = FastAPI(
    debug=debug,
    title=app_name,
    version=app_version,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health():
    return {"status": "ok", "app": app_name, "version": app_version}


AuthRouter(app).init_routes()


# @app.get("/")
# def AuthService():
#     return {"message": "E-Disposal Government Application API Services"}
