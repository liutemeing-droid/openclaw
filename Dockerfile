# 1. 使用正確的 Node.js 22 版本
FROM node:22-slim

# 設定工作目錄
WORKDIR /app

# 2. 安裝系統相依性與 Go 環境 (解決 ordercli 的需求)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libssl-dev \
    libffi-dev \
    wget \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# 3. 全域安裝必要工具：pnpm, uv (針對 nano-pdf), 以及 summarize 工具本身
RUN npm install -g pnpm @steipete/summarize clawhub
# 安裝 uv (Python 套件管理器)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin/:$PATH"

# 4. 複製專案檔案並安裝 OpenClaw 依賴
COPY . .
RUN pnpm install

# 5. 執行專案建置 (這是之前缺失的關鍵步驟)
RUN pnpm build

# 6. 啟動指令 (使用 pnpm start)
CMD ["pnpm", "start"]
