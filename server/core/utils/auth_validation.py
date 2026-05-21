# from dataclasses import dataclass
# from fastapi import HTTPException
# from sqlalchemy.orm import Session
# from fastapi import Depends

# from core.utils.dbConnection import DatabaseConnection
# from data.entity.auth.client import ClientAuthEntity
# from core.constants.config import DB_URL


# class ClientAuthValidation:
#     session_conn = DatabaseConnection(DB_URL).set_db

#     @classmethod
#     def validate_email(cls, email: str, db: Session = Depends(session_conn)):


#     @classmethod
#     def validate_password(cls, password: str, confirm_password: str) -> HTTPException:
