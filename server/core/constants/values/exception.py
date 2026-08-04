from enum import Enum


class DBConnnectionException(Enum):
    NOT_FOUND = "Database not initialized."


class AuthString(Enum):
    NO_TOKEN = "No auth token, Access Denied!"
    TOKEN_VERIFICATION = "Token verification failed, Authorization Error!"
    FAILED_AUTHORIZATION = "Authorization Failed, Token is Not Valid"
    EMAIL_ALREADY_EXISTS = "Email Already Registered!"
    FIELD_EMPTY = "Fields are Empty!"
    PASSWORD_INCORRECT = "Password Incorrect!"
    MIDDLEWARE_ERROR = "ERROR: "
    USER_NOT_FOUND = "User not found!"
