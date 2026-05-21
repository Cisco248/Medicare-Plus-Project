from fastapi import FastAPI

from core.constants.config import app_name, app_version, debug
from repository.routes.auth_router import AuthRouter
from data.models.base import BASE

# BASE.metadata.create_all(bind=DatabaseConnection.engine)

app = FastAPI(
    debug=debug,
    title=app_name,
    version=app_version,
)

AuthRouter(app).init_routes()


# @app.get("/")
# def AuthService():
#     return {"message": "E-Disposal Government Application API Services"}
