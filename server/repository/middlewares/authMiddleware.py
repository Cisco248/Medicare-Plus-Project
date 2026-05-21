from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token=Header()):
    """
    Authenticate requests using JWT tokens from the Authorization header.
    This middleware function validates JWT tokens passed via the X-Auth-Token header.
    It decodes the token using HS256 algorithm and extracts the user ID from the token payload.
    Args:
        x_auth_token (str): JWT token from the X-Auth-Token header.
    Returns:
        dict: A dictionary containing:
            - uid (str): The user ID extracted from the token payload.
            - token (str): The original JWT token.
    Raises:
        HTTPException:
            - 401 status code if no token is provided.
            - 401 status code if token verification fails.
            - 401 status code if token is invalid or decoding fails (PyJWTError).
    Example:
        >>> auth_middleware(x_auth_token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
        {'uid': '12345', 'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'}
    """
    try:
        if not x_auth_token:
            raise HTTPException(status_code=401, detail="No auth token, Access Denied!")

        verify_token = jwt.decode(
            x_auth_token, key="password_key", algorithms=["HS256"]
        )
        if not verify_token:
            raise HTTPException(
                status_code=401,
                detail="Token verification failed, Authorization Error!",
            )

        uid = verify_token.get("id")
        return {"uid": uid, "token": x_auth_token}

    except jwt.PyJWTError:
        raise HTTPException(
            status_code=401, detail="Authorization Failed, Token is Not Valid"
        )
