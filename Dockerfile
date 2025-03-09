FROM ubuntu:24.04

# Add the UV binary to the image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set environment variables to avoid interaction during installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
apt-get install -y --no-install-recommends \
ca-certificates \
curl \
build-essential \
git \
python3 \
pkg-config \
python3-icu \
libicu-dev && \
rm -rf /var/lib/apt/lists/*


RUN useradd -m -s /bin/bash -u 1000 user
USER user

WORKDIR /app

RUN uv python install 3.11
RUN uv python pin 3.11
RUN id

COPY pyproject.toml pyproject.toml
RUN uv sync --extra cpu --no-dev

COPY --chown=user . /app
CMD [".venv/bin/python", "src/app.py"]