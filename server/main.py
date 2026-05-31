import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from core.constants.config import (
    APP_NAME,
    APP_VERSION,
    DEBUG,
    HOST,
    PORT,
    CORS_ORIGIN,
)
from repository.routes import initial_router, auth_router, ocr_router, har_router
from data.models.base import BASE
from core.utils.dbConnection import engine

BASE.metadata.create_all(bind=engine, checkfirst=True)


app = FastAPI(debug=DEBUG, title=APP_NAME, version=APP_VERSION)

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGIN,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(router=initial_router.router)
app.include_router(router=auth_router.router, prefix="/api")
app.include_router(router=ocr_router.router, prefix="/api-ocr")
app.include_router(router=har_router.router, prefix="/api-har")


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=PORT, reload=True)
