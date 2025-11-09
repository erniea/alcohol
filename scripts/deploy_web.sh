#!/bin/bash

# Flutter Web 배포 스크립트 (SCP)
# 사용법: ./scripts/deploy_web.sh

# 배포 설정 (여기를 수정하세요)
SERVER_USER="erniea"
SERVER_HOST="firecrac.kr"
SERVER_PATH="/home/erniea/www/flutter/alcohol/build/web"
BUILD_DIR="build/web"

echo "🚀 Flutter Web 배포 시작..."

# 빌드 디렉토리 확인
if [ ! -d "$BUILD_DIR" ]; then
  echo "❌ 빌드 디렉토리가 없습니다. 먼저 빌드를 실행하세요."
  echo "   ./scripts/build_web.sh"
  exit 1
fi

# 서버에 업로드
echo "📦 서버로 파일 업로드 중..."
scp -r $BUILD_DIR/* $SERVER_USER@$SERVER_HOST:$SERVER_PATH/

if [ $? -eq 0 ]; then
  echo "✅ 배포 완료!"
  echo "   서버: $SERVER_USER@$SERVER_HOST:$SERVER_PATH"
else
  echo "❌ 배포 실패"
  exit 1
fi
