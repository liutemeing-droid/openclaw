# 1. 使用 Node.js 22
FROM node:22-slim

# 設定工作目錄
WORKDIR /app

# 2. 安裝系統相依性（新增了 ca-certificates 解決下載問題）
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

# 3. 全域安裝 pnpm, summarize, clawhub
RUN npm install -g pnpm @steipete/summarize clawhub

# 4. 安裝 uv 並立即安裝 nano-pdf
# 我們把這兩步結合，並確保路徑正確
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin/:$PATH"
RUN /root/.local/bin/uv tool install nano-pdf

# 5. 複製專案檔案並安裝 OpenClaw 依賴
COPY . .
RUN pnpm install

# 6. 執行專案建置
RUN pnpm build

# 7. 啟動指令
CMD ["pnpm", "start"]
