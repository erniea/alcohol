#!/bin/bash
set -e

# React 웹 프로덕션 빌드 스크립트
# 사용법: ./scripts/build_web.sh

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "🔨 React 웹 빌드 시작..."
cd "$ROOT/frontend"

# 의존성 설치 (lockfile 기준, 없으면 install)
if [ -f package-lock.json ]; then
  npm ci
else
  npm install
fi

npm run build

echo "✅ 빌드 완료: frontend/dist/"
