FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

RUN pip install uv

WORKDIR /server

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-dev


FROM python:3.12-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/server/.venv/bin:$PATH"

WORKDIR /server

COPY --from=builder /server/.venv /server/.venv

RUN mkdir -p /app/data

COPY . .

COPY ./artifact/ /app/data/

EXPOSE 8080

HEALTHCHECK --interval=30s \
    --timeout=10s \
    --start-period=20s \
    --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1

CMD [ "python", "main.py" ]
