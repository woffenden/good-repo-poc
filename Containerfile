##################################################
# Stage: Build
# From: cgr.dev/chainguard/python:latest-dev
##################################################
FROM cgr.dev/chainguard/python:latest-dev@sha256:83368419da958ef8f7b049c1dc52238a77a8daa2ed1f264e2fb8444bc9f82b06 AS build

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:python3.13-alpine@sha256:d911044652e6f56d74ee0c68c4aced000cc51cc3cef4f56ace668d88d3e7e5f2 /usr/local/bin/uv /usr/local/bin/uv

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-editable

##################################################
# Stage: Final
# From: cgr.dev/chainguard/python:latest
##################################################
FROM cgr.dev/chainguard/python:latest@sha256:0ed9f745adb1df1131a46e89945bde7117eadde7b904c74188ec81df3f488c2b AS final

WORKDIR /app

COPY --from=build /app/.venv /app/.venv
COPY app/ /app

ENTRYPOINT ["/app/.venv/bin/python", "main.py"]
