#!/bin/bash
set -e

# React 웹 빌드 & 배포 스크립트 (rsync)
# 사용법: ./scripts/deploy_web.sh

# ===== 배포 설정 (여기를 수정하세요) =====
SERVER_USER="erniea"
SERVER_HOST="firecrac.kr"
# nginx가 서빙하는 웹 루트. 이 경로의 내용이 dist와 동일하게 동기화됩니다.
SERVER_PATH="/home/erniea/www/flutter/alcohol/build/web"
# ========================================

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/frontend/dist"

echo "🚀 React 웹 배포 시작..."

# 1) 빌드
"$ROOT/scripts/build_web.sh"

if [ ! -d "$DIST" ]; then
  echo "❌ 빌드 산출물이 없습니다: $DIST"
  exit 1
fi

# 2) 서버로 동기화
#    --delete: 서버에 남아 있는 구 Flutter 산출물(main.dart.js, canvaskit/,
#    flutter_service_worker.js 등)을 제거해 깨끗이 교체합니다.
#    주의: SERVER_PATH 내용이 dist로 완전히 대체됩니다. 경로가 정확한지 확인하세요.
echo "📦 $SERVER_USER@$SERVER_HOST:$SERVER_PATH 로 동기화 중..."
rsync -avz --delete "$DIST/" "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/"

echo "✅ 배포 완료: $SERVER_USER@$SERVER_HOST:$SERVER_PATH"
echo ""
echo "ℹ️  nginx에 SPA 폴백이 필요합니다 (없으면 /admin 새로고침 시 404):"
echo "      location / { try_files \$uri \$uri/ /index.html; }"
echo "ℹ️  구 Flutter 서비스워커가 캐시된 기존 방문자는 최신 화면을 보려면"
echo "    한 번 강력 새로고침(또는 캐시 삭제)이 필요할 수 있습니다."
