##################################################
# Stage: Build
# From: docker.io/chainguard/python:latest-dev
##################################################
FROM docker.io/chainguard/python:latest-dev@sha256:83368419da958ef8f7b049c1dc52238a77a8daa2ed1f264e2fb8444bc9f82b06 AS builder

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:python3.13-alpine /usr/local/bin/uv /usr/local/bin/uv

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-editable --no-dev

##################################################
# Stage: Final
# From: docker.io/chainguard/python:latest
##################################################
FROM docker.io/chainguard/python:latest@sha256:0ed9f745adb1df1131a46e89945bde7117eadde7b904c74188ec81df3f488c2b AS final

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
COPY app/ /app

ENTRYPOINT ["/app/.venv/bin/python", "main.py"]
