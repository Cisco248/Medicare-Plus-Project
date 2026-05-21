from core.constants.config import DB_URL
from fastapi import FastAPI
from core.utils.dbConnection import DatabaseConnection
from .auth import client_router, admin_router

db = DatabaseConnection(DB_URL)


class AuthRouter:
    def __init__(self, app: FastAPI):
        self.app = app

    def init_routes(self):
        self.app.include_router(router=client_router.router, prefix="/client")
        self.app.include_router(router=admin_router.router, prefix="/admin")
