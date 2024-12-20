FROM python:3.13-slim AS base

FROM base AS dependencies

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Change the working directory to the `app` directory
WORKDIR /app

# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-editable --compile-bytecode

FROM base AS runner
WORKDIR /app

# Copy the environment
COPY --from=dependencies --chown=app:app /app/.venv /app/.venv

# Copy the application
COPY ./main.py /app

# Run the application
CMD [".venv/bin/python", "main.py"]