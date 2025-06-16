#!/bin/bash

# 停止 Java 服务
echo "停止 Java 服务..."
pkill -f 'java -jar ./admin/target/shortlink-admin.jar'
pkill -f 'java -jar ./gateway/target/shortlink-gateway.jar'
pkill -f 'java -jar ./project/target/shortlink-project.jar'

# 停止 Docker Compose 服务
echo "停止 Docker Compose 服务..."
docker-compose down

# 可选：删除日志文件
echo "🧹 清理日志..."
rm -rf ./logs

echo "服务已关闭并清理完成！"
