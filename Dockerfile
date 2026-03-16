FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:/root/.local/bin:${PATH}"

WORKDIR /opt/render/project/src

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    ffmpeg \
    git \
    tini \
 && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

COPY . .

RUN git clone https://github.com/SWE-agent/mini-swe-agent /opt/mini-swe-agent \
 && git -C /opt/mini-swe-agent checkout 07aa6a738556e44b30d7b5c3bbd5063dac871d25 \
 && uv venv "${VIRTUAL_ENV}" --python 3.11 \
 && uv pip install -e '.[messaging,cron,pty,mcp]' \
 && uv pip install -e /opt/mini-swe-agent \
 && npm ci \
 && npm ci --prefix scripts/whatsapp-bridge \
 && rm -rf /root/.cache /tmp/*

ENTRYPOINT ["/usr/bin/tini", "--", "/opt/render/project/src/scripts/render-start.sh"]
