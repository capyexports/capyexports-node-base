# Base image: capyexports-node-base
# Node.js 22 Alpine, minimal runtime only
# Version: 1.0.0
FROM node:22-alpine

LABEL maintainer="capyexports"
LABEL version="1.0.0"
LABEL description="Node.js 22 base image for capyexports projects (Alpine)"

# Timezone: Asia/Shanghai (requires tzdata)
RUN apk add --no-cache tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

# npm registry: use npmmirror (China)
RUN npm config set registry https://registry.npmmirror.com

# No extra dependencies; keep image minimal (runtime essentials only)

WORKDIR /app

# Run as non-root (USER node)
USER node

CMD ["node"]
