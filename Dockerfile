# Base image
FROM python:3.13-slim AS base

# Builder image
FROM base AS builder

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Change the working directory to the `app` directory
WORKDIR /app

# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-editable --compile-bytecode

# Install the application
ADD . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-editable --compile-bytecode

# Runner image
FROM gcr.io/distroless/python3-debian12 AS runner

# Copy the virtual environment
COPY --from=builder --chown=app:app /app/.venv /app/.venv

# Add the path to the virtual environment to the PYTHONPATH
ENV PYTHONPATH=/app/.venv/lib/python3.13/site-packages:$PYTHONPATH

# Run the application
CMD ["/app/.venv/bin/main"]