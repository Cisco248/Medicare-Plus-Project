import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from core import ServerSettings
from repository import (
    init_router,
    auth_router,
    har_router,
    base_model_router,
    document_router,
)
from data import BASE
from core import DBConnection
from repository.middlewares.document_middleware import DocumentMiddleware

BASE.metadata.create_all(bind=DBConnection.ENGINE, checkfirst=True)
DocumentMiddleware.ensure_optional_columns(DBConnection.ENGINE)
setting = ServerSettings()


app = FastAPI(debug=setting.DEBUG, title=setting.APP_NAME, version=setting.APP_VERSION)

app.add_middleware(
    CORSMiddleware,
    allow_origins=setting.CORS_ORIGIN,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(router=init_router)
app.include_router(router=auth_router, prefix="/api")
app.include_router(router=document_router, prefix="/api")
app.include_router(router=har_router, prefix="/api-har")
app.include_router(router=base_model_router, prefix="/api-base")


if __name__ == "__main__":
    uvicorn.run("main:app", host=setting.APP_HOST, port=setting.APP_PORT, reload=True)
