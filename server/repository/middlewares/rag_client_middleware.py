from typing import Any
import httpx


class RagClientMiddleware:
    def __init__(self, url: str, data: Any) -> None:
        self.url = url
        self.data = data

    async def build(self):
        async with httpx.AsyncClient() as client:
            respone = await client.post(self.url, data=self.data)
            return respone
