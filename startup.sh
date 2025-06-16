#!/bin/bash

set -e

# 定义 Java 服务（名称 JAR路径 项目路径 启动端口）
SERVICES=(
  "AdminService ./admin/target/shortlink-admin.jar admin 8002"
  "ProjectService ./project/target/shortlink-project.jar project 8001"
  "GatewayService ./gateway/target/shortlink-gateway.jar gateway 8000"
)

# 定义要等待健康的容器名（与 docker-compose.yml 中保持一致）
CONTAINERS=("mysql" "redis" "nacos-server")

# 打包
echo "🔨 开始打包所有服务..."
for SERVICE in "${SERVICES[@]}"; do
  NAME=$(echo $SERVICE | awk '{print $1}')
  JAR=$(echo $SERVICE | awk '{print $2}')
  MOUDLE=$(echo $SERVICE | awk '{print $3}')

  echo "📦 打包 $NAME..."
  chmod +x mvnw
  (./mvnw -pl $MOUDLE clean package -DskipTests)

  if [ ! -f "$JAR" ]; then
    echo "❌ 打包失败：未找到 $JAR"
    exit 1
  fi
done

echo "✅ 所有服务打包完成！"

# 启动容器
echo "🟡 启动 Docker Compose 容器..."
docker compose up -d

# 等待容器健康检查通过
wait_for_container_healthy() {
  local NAME=$1
  local RETRIES=30
  local COUNT=0

  echo "⏳ 等待容器 $NAME 健康..."

  until [ "$(docker inspect -f '{{.State.Health.Status}}' "$NAME")" == "healthy" ]; do
    sleep 2
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $RETRIES ]; then
      echo "❌ 容器 $NAME 健康检查超时"
      exit 1
    fi
  done

  echo "✅ 容器 $NAME 已通过健康检查"
}

for NAME in "${CONTAINERS[@]}"; do
  wait_for_container_healthy "$NAME"
done

# 等待端口可用
wait_for_port() {
  local PORT=$1
  local NAME=$2
  local RETRIES=300
  local COUNT=0

  echo "⏳ 等待服务 $NAME 端口 $PORT 启动..."
  until nc -z localhost $PORT; do
    sleep 1
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $RETRIES ]; then
      echo "❌ 端口 $PORT 启动超时"
      exit 1
    fi
  done
  echo "✅ 服务 $NAME 已启动在端口 $PORT"
}

wait_for_service_in_eureka() {
  local SERVICE_NAME=$1
  local RETRIES=30
  local COUNT=0

  echo "⏳ 等待服务 $SERVICE_NAME 注册到 Eureka..."
  until curl -s http://localhost:8761/eureka/apps/$SERVICE_NAME | grep -q "<status>UP</status>"; do
    sleep 1
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $RETRIES ]; then
      echo "❌ 服务 $SERVICE_NAME 未注册或未启动"
      exit 1
    fi
  done
  echo "✅ 服务 $SERVICE_NAME 已注册并处于 UP 状态"
}


# 启动 Spring Boot 服务
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
for SERVICE in "${SERVICES[@]}"; do
  NAME=$(echo $SERVICE | awk '{print $1}')
  JAR=$(echo $SERVICE | awk '{print $2}')
  PORT=$(echo $SERVICE | awk '{print $4}')
  LOG="${LOG_DIR}/${NAME}.log"

  echo "🟢 启动 $NAME..."
  nohup java -jar "$JAR" > "$LOG" 2>&1 &
#  nohup java -jar "$JAR" > /dev/null 2>&1 &

  wait_for_port "$PORT" "$SERVICE_NAME"
done

echo "🚀 启动 Vue 前端服务..."

# 项目根目录路径（可根据实际情况修改）
PROJECT_DIR="console-vue"

cd "$PROJECT_DIR"

# 启动前端服务并保存进程号到 vue.pid
nohup npm run dev > vue.log 2>&1 &

# 保存进程号到 vue.pid 方便 shutdown.sh 使用
echo $! > vue.pid

echo "✅ Vue 服务已启动，日志输出到 vue.log"

echo "🎉 所有容器与微服务均已成功启动！"
