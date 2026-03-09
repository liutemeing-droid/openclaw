# 使用 Node.js 22 基礎映像檔
FROM node:22-slim

# 設定工作目錄
WORKDIR /app

# 安裝系統相依性
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

# ！！！關鍵增加：先執行專案建置 ！！！
RUN pnpm build

# 建置完後，再安裝 summarize 技能
RUN npx openclaw skill install summarize

# 啟動指令
CMD ["pnpm", "start"]
