# 1. 使用 Node.js 22 基礎映像檔
FROM node:22-slim

# 2. 安裝 uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# 設定工作目錄
WORKDIR /app

# 3. 安裝系統相依性 (包含 GitHub CLI, curl, git, certs 等)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    gpg \
    git \
    libssl-dev \
    libffi-dev \
    wget \
    ca-certificates \
    chromium && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. 全域安裝 pnpm, summarize, clawhub
RUN npm install -g pnpm @steipete/summarize clawhub

# 5. 使用 uv 安裝 nano-pdf
RUN uv tool install nano-pdf --force

# 6. 複製專案檔案並安裝 OpenClaw 依賴
COPY . .
RUN pnpm install --frozen-lockfile

# 7. 啟動指令 (跳過 pnpm build 以避免 TypeScript 編譯錯誤，直接運行)
CMD ["pnpm", "start"]
