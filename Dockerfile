# 使用 Node.js 20 基礎映像檔
FROM node:20-slim

# 設定工作目錄
WORKDIR /app

# 安裝系統相依性 (解決技能安裝問題的核心)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# 全域安裝 pnpm
RUN npm install -g pnpm

# 複製專案檔案
COPY . .

# 安裝專案依賴
RUN pnpm install

# 在建置時預先安裝 summarize 技能
RUN npx openclaw skill install summarize

# 啟動指令 (通常是 pnpm start)
CMD ["pnpm", "start"]
