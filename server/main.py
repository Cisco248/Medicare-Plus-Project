import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from core.utils.dbConnection import DatabaseConnection

from core.constants.config import (
    app_name,
    app_version,
    debug,
    cors_origins,
    host,
    port,
    DB_URL,
)
from data.models.base import BASE
from repository.routes import initial_router
from repository.routes import auth_router

app = FastAPI(debug=debug, title=app_name, version=app_version)

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

db = DatabaseConnection(DB_URL)
db.init_db(BASE)

app.include_router(router=initial_router.router)
app.include_router(router=auth_router.router, prefix="/api")


if __name__ == "__main__":
    uvicorn.run("main:app", host=host, port=port, reload=True)
