#!/bin/bash

# 停止 Java 服务
echo "停止 Java 服务..."
pkill -f 'java -jar ./admin/target/shortlink-admin.jar'
pkill -f 'java -jar ./gateway/target/shortlink-gateway.jar'
pkill -f 'java -jar ./project/target/shortlink-project.jar'

PROJECT_DIR="console-vue"
PID_FILE="$PROJECT_DIR/vue.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    echo "🛑 正在关闭 Vue 服务，PID=$PID"
    kill $PID

    # 可选：确认是否成功杀死
    sleep 2
    if ps -p $PID > /dev/null; then
        echo "⚠️ 无法关闭进程 $PID，尝试强制终止"
        kill -9 $PID
    fi

    rm -f "$PID_FILE"
    rm -f "console-vue/vue.log"
    echo "✅ Vue 服务已停止"
else
    echo "❌ 未找到 vue.pid，Vue 服务可能未启动或 PID 文件丢失"
fi

# 停止 Docker Compose 服务
echo "停止 Docker Compose 服务..."
docker-compose down

# 可选：删除日志文件
echo "🧹 清理日志..."
rm -rf ./logs

echo "服务已关闭并清理完成！"
