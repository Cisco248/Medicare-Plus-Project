from typing import Any

import httpx


class RagClientError(Exception):
    def __init__(self, message: str, status_code: int | None = None) -> None:
        super().__init__(message)
        self.status_code = status_code


class RagClientMiddleware:
    def __init__(self, url: str, data: Any) -> None:
        self.url = url
        self.data = data

    async def build(self):
        async with httpx.AsyncClient() as client:
            respone = await client.post(self.url, data=self.data)
            return respone
