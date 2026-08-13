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


class DocumentString(Enum):
    NOT_FOUND = "Document not found!"
    INVALID_FILE_TYPE = "Unsupported file type! Allowed types: pdf, jpg, jpeg, png."
    FILE_TOO_LARGE = "File is too large! Maximum size is 10 MB."
    FILE_EMPTY = "Uploaded file is empty!"
    FILE_MISSING = "Stored file could not be found!"
    INVALID_STATUS = "Invalid document status!"
    FIELD_EMPTY = "Title and document type are required!"
