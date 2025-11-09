# Alcohol - 칵테일 레시피 관리 앱

Flutter로 개발된 칵테일 레시피 관리 및 평가 애플리케이션입니다.

## 주요 기능

- 🍸 칵테일 레시피 검색 및 필터링
- 📝 재료 기반 필터링
- 💬 Firebase 인증을 통한 평가 및 댓글 시스템
- 👨‍💼 관리자 모드 (재료 관리, 칵테일 관리)
- 🌙 다크 모드 지원
- 📱 Material Design 3 UI

## 기술 스택

- **Framework**: Flutter 3.0+
- **상태 관리**: Riverpod 2.6+
- **인증**: Firebase Auth + Google OAuth
- **UI**: Material Design 3
- **환경 변수**: flutter_dotenv

## 시작하기

### 1. 저장소 클론

```bash
git clone https://github.com/yourusername/alcohol.git
cd alcohol
```

### 2. 환경 변수 설정

`.env.example` 파일을 복사하여 `.env` 파일을 생성합니다:

```bash
cp .env.example .env
```

`.env` 파일을 열고 Firebase 설정값을 입력합니다:

```env
# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_APP_ID=your_firebase_app_id
FIREBASE_MEASUREMENT_ID=your_measurement_id

# Google OAuth
GOOGLE_CLIENT_ID=your_google_client_id_here
```

### 3. Firebase 설정

1. [Firebase Console](https://console.firebase.google.com/)에서 새 프로젝트 생성
2. Authentication에서 Google 로그인 활성화
3. 웹 앱 추가 후 설정값을 `.env` 파일에 입력

### 4. 의존성 설치

```bash
flutter pub get
```

### 5. 코드 생성 (Riverpod)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. 앱 실행

```bash
flutter run
```

## 프로젝트 구조

```
lib/
├── core/
│   ├── providers/        # Riverpod service providers
│   └── constants/        # API URLs, App 설정, 테마
├── models/              # 데이터 모델 (Base, Drink, Recipe, Comment)
├── services/            # API 서비스 레이어
│   ├── drink_service.dart
│   ├── base_service.dart
│   ├── comment_service.dart
│   └── recipe_service.dart
├── features/            # 기능별 모듈
│   ├── drinks/
│   │   ├── providers/   # Drink 관련 providers
│   │   ├── widgets/     # Drink 관련 위젯
│   │   └── screens/     # Drink 화면
│   ├── admin/          # 관리자 기능
│   └── social/         # 평가 및 댓글 기능
└── main.dart
```

## 개발 가이드

### 새로운 Provider 추가

1. `*.dart` 파일에 `@riverpod` 어노테이션 추가
2. `part '파일명.g.dart';` 추가
3. Provider 작성 후 코드 생성 실행:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### 환경 변수 추가

1. `.env` 파일에 새 변수 추가
2. `.env.example`에도 예제 추가
3. `lib/core/constants/app_constants.dart`에 getter 추가

## 보안

- ⚠️ `.env` 파일은 **절대** Git에 커밋하지 마세요
- `.env` 파일은 `.gitignore`에 이미 추가되어 있습니다
- 프로젝트를 공유할 때는 `.env.example`만 포함하세요

## 라이선스

이 프로젝트는 개인 프로젝트입니다.

## 기여

기여는 환영합니다! Pull Request를 보내주세요.
