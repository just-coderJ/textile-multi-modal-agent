#!/bin/bash
echo "=== 开始重新部署 ==="

# 强制重新拉取最新的镜像（如果用了镜像仓库）
# docker compose pull
# 重新构建并后台启动（会自动检测变化的文件并重建）
docker compose up -d --build
echo "=== 部署完成 ==="