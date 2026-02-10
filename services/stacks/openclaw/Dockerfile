FROM node:22-bookworm

# Install Bun (required for build scripts)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

RUN corepack enable

# Install apt packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      git \
      vim \
      curl \
      wget \
      jq \
      python3 \
      python3-pip \
      python3-venv \
      openssh-client \
      ca-certificates \
      gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for DinD communication)
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone and build OpenClaw
WORKDIR /app
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

RUN pnpm install --frozen-lockfile

RUN OPENCLAW_A2UI_SKIP_MISSING=1 pnpm build
ENV OPENCLAW_PREFER_PNPM=1
RUN pnpm ui:build

ENV NODE_ENV=production

# Allow non-root user to write temp files
RUN chown -R node:node /app

USER node

CMD ["node", "openclaw.mjs", "gateway", "--allow-unconfigured", "--bind", "lan"]
