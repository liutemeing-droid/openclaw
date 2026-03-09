# 1. 使用 Node.js 22 基礎映像檔
FROM node:22-slim

# 2. 【關鍵：從官方映像檔直接複製 uv】
# 這樣我們百分之百確定 uv 會在 /bin/uv，絕對找得到！
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# 設定工作目錄
WORKDIR /app

# 3. 安裝系統相依性 (包含憑證與 Go)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libssl-dev \
    libffi-dev \
    wget \
    golang-go \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 4. 全域安裝 pnpm, summarize, clawhub
RUN npm install -g pnpm @steipete/summarize clawhub

# 5. 因為我們已經有了 uv，直接安裝 nano-pdf
# 加上 --system 確保它裝在系統環境中
RUN uv tool install nano-pdf --force

# 6. 複製專案檔案並安裝 OpenClaw 依賴
COPY . .
RUN pnpm install

# 7. 執行專案建置
RUN pnpm build

# 8. 啟動指令
CMD ["pnpm", "start"]
