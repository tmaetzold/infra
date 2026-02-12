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
      build-essential \
      procps \
      file \
      # CalDAV tools
      vdirsyncer \
      khal \
      todoman \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for DinD communication)
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (static binary)
RUN GH_VERSION=$(curl -sL https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name | sed 's/^v//') && \
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" | \
    tar xz -C /usr/local/bin --strip-components=2 --wildcards '*/bin/gh'

# Install Himalaya (static binary)
RUN HIMALAYA_VERSION=$(curl -sL https://api.github.com/repos/pimalaya/himalaya/releases/latest | jq -r .tag_name) && \
    curl -fsSL "https://github.com/pimalaya/himalaya/releases/download/${HIMALAYA_VERSION}/himalaya.x86_64-linux.tgz" | \
    tar xz -C /usr/local/bin himalaya

# Install uv (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    cp /root/.local/bin/uv /usr/local/bin/uv && \
    cp /root/.local/bin/uvx /usr/local/bin/uvx 2>/dev/null || true

# Clone and build OpenClaw
WORKDIR /app
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

RUN pnpm install --frozen-lockfile

RUN OPENCLAW_A2UI_SKIP_MISSING=1 pnpm build
ENV OPENCLAW_PREFER_PNPM=1
RUN pnpm ui:build

ENV NODE_ENV=production

# Create openclaw user with home dir and set ownership
RUN useradd -m -s /bin/bash openclaw && \
    chown -R openclaw:openclaw /app

USER openclaw

CMD ["node", "openclaw.mjs", "gateway", "--allow-unconfigured", "--bind", "lan"]
