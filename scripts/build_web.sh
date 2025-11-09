#!/bin/bash

# Flutter Web 프로덕션 빌드 스크립트
# 사용법: ./scripts/build_web.sh

echo "🔨 Flutter Web 빌드 시작..."

# .env 파일에서 환경 변수 읽기
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# --dart-define으로 환경 변수 전달
flutter build web \
  --dart-define=FIREBASE_API_KEY=$FIREBASE_API_KEY \
  --dart-define=FIREBASE_AUTH_DOMAIN=$FIREBASE_AUTH_DOMAIN \
  --dart-define=FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID \
  --dart-define=FIREBASE_STORAGE_BUCKET=$FIREBASE_STORAGE_BUCKET \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=$FIREBASE_MESSAGING_SENDER_ID \
  --dart-define=FIREBASE_APP_ID=$FIREBASE_APP_ID \
  --dart-define=FIREBASE_MEASUREMENT_ID=$FIREBASE_MEASUREMENT_ID \
  --dart-define=GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID \
  --dart-define=DEFAULT_DRINK_IMAGE=$DEFAULT_DRINK_IMAGE \
  --release

echo "✅ 빌드 완료: build/web/"
