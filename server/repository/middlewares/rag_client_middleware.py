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
        try:
            async with httpx.AsyncClient(timeout=60.0) as client:
                response = await client.post(self.url, json=self.data)
                response.raise_for_status()
                return response
        except httpx.TimeoutException as exc:
            raise RagClientError(
                "The assessment service timed out. Please try again.",
                status_code=504,
            ) from exc
        except httpx.HTTPStatusError as exc:
            status_code = exc.response.status_code
            detail = _detail_from_response(exc.response)
            if status_code == 503:
                message = detail or "The assessment service is not ready."
            elif status_code >= 500:
                message = detail or "The assessment service failed."
            else:
                message = detail or "The assessment service rejected the request."
            raise RagClientError(message, status_code=status_code) from exc
        except httpx.RequestError as exc:
            raise RagClientError(
                "Unable to reach the assessment service.",
                status_code=503,
            ) from exc


def _detail_from_response(response: httpx.Response) -> str | None:
    try:
        payload = response.json()
    except ValueError:
        text = response.text.strip()
        return text or None
    if isinstance(payload, dict) and isinstance(payload.get("detail"), str):
        return payload["detail"]
    if isinstance(payload, str) and payload.strip():
        return payload.strip()
    return None
