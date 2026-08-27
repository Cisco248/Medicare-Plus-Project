import logging
from contextlib import asynccontextmanager
import uvicorn
from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException

from core.utils import DBConnection, download_models
from core.configs import ServerSettings
from data.models import BASE
from repository.routes import (
    auth_router,
    base_model_router,
    har_router,
    health_activity_router,
    init_router,
)
from repository.middlewares.document_middleware import DocumentMiddleware
from repository.middlewares.schema_middleware import SchemaMiddleware

setting = ServerSettings()
logger = logging.getLogger("medicare.server")


def initialize_database() -> None:
    BASE.metadata.create_all(bind=DBConnection.ENGINE, checkfirst=True)
    DocumentMiddleware.ensure_optional_columns(DBConnection.ENGINE)
    SchemaMiddleware.ensure_optional_columns(DBConnection.ENGINE)


@asynccontextmanager
async def lifespan(_app: FastAPI):
    initialize_database()
    yield


app = FastAPI(
    debug=setting.DEBUG,
    title=setting.APP_NAME,
    version=setting.APP_VERSION,
    lifespan=lifespan,
    description=(
        "MediCare Plus backend. Patients may only access their own health "
        "records. AI output is decision support, not a diagnosis."
    ),
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=setting.CORS_ORIGIN,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.exception_handler(StarletteHTTPException)
async def http_exception_handler(_request: Request, exc: StarletteHTTPException):
    return JSONResponse(status_code=exc.status_code, content={"detail": exc.detail})


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(_request: Request, exc: RequestValidationError):
    return JSONResponse(status_code=422, content={"detail": exc.errors()})


@app.exception_handler(Exception)
async def unhandled_exception_handler(_request: Request, exc: Exception):
    logger.exception("Unhandled server error")
    return JSONResponse(
        status_code=500,
        content={"detail": "An unexpected server error occurred."},
    )


app.include_router(router=init_router)
app.include_router(router=auth_router, prefix="/api")
app.include_router(router=health_activity_router, prefix="/api")
app.include_router(router=har_router, prefix="/api-har")
app.include_router(router=base_model_router, prefix="/api-base")


if __name__ == "__main__":
    download_models()
    uvicorn.run("main:app", host=setting.APP_HOST, port=setting.APP_PORT, reload=True)
