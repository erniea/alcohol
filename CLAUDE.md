# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

Flutter로 구축된 칵테일 레시피 관리 앱입니다. 사용자는 재료(base)의 재고 상태에 따라 칵테일 목록을 필터링하고, 칵테일 레시피를 조회하며, Firebase 인증을 통해 평점과 코멘트를 작성할 수 있습니다.

## 개발 명령어

### 종속성 설치
```bash
flutter pub get
```

### 앱 실행
```bash
# 개발 모드로 실행
flutter run

# 웹으로 실행
flutter run -d chrome

# iOS 시뮬레이터로 실행
flutter run -d ios

# Android 에뮬레이터로 실행
flutter run -d android
```

### 빌드
```bash
# Android APK 빌드
flutter build apk

# iOS 빌드
flutter build ios

# 웹 빌드
flutter build web
```

### 테스트
```bash
# 모든 테스트 실행
flutter test

# 특정 테스트 파일 실행
flutter test test/widget_test.dart
```

### 코드 분석
```bash
# 린트 검사
flutter analyze
```

## 아키텍처 및 코드 구조

### 핵심 데이터 모델 (lib/ds.dart)

앱의 모든 데이터 구조는 `lib/ds.dart`에 정의되어 있습니다:

- **Base**: 칵테일의 재료 (예: 보드카, 럼, 진 등)
  - `idx`: 고유 ID
  - `name`: 재료 이름
  - `inStock`: 재고 보유 여부

- **RecipeElement**: 레시피의 한 재료 항목
  - `idx`: 고유 ID
  - `base`: Base 객체
  - `volume`: 재료의 양 (예: "30ml")

- **Recipe**: 칵테일 레시피
  - `elements`: RecipeElement 리스트
  - `available`: 모든 재료가 재고에 있는지 여부 (자동 계산)

- **Drink**: 칵테일
  - `idx`: 고유 ID
  - `name`: 칵테일 이름
  - `desc`: 설명
  - `img`: 이미지 URL
  - `recipe`: Recipe 객체

- **Comment**: 사용자 평가
  - `idx`: 고유 ID
  - `uid`: Firebase 사용자 ID
  - `star`: 별점 (1-5)
  - `comment`: 코멘트 내용

### 주요 화면 및 기능

#### 1. 메인 화면 (AlcoholDrinks in lib/main.dart)

- **PageView 구조**: 수평 스와이프로 두 페이지 전환
  - 첫 번째 페이지: 칵테일 목록 (검색 + 수직 스크롤)
  - 두 번째 페이지: 소셜 페이지 (평점/코멘트)

- **필터링 시스템**:
  - `baseFilter`: 선택된 재료 ID 세트 (Drawer의 SelectPage에서 관리)
  - `textFilter`: 칵테일 이름 검색어
  - 필터는 `build()` 메서드에서 실시간으로 적용됨

- **DrinkCard**: 탭으로 상세 정보 ↔ 레시피 간 플립 애니메이션

#### 2. 관리자 화면 (AlcoholAdmin in lib/main.dart)

경로: `/admin`

- **PageView 구조**: 두 페이지로 구성
  - BaseMgr: 재료 관리
  - DrinkMgr: 칵테일 및 레시피 관리

- FloatingActionButton으로 항목 추가 (BottomSheet 사용)

#### 3. 재료 관리 (lib/baseMgr.dart)

- **BaseMgr**: 재료 목록 표시 및 편집
  - SwitchListTile로 재고 상태 토글
  - TextFormField로 재료 이름 인라인 편집
  - API 호출: `updateBaseInStock()`, `updateBaseName()`

- **BaseInput**: 새 재료 추가 폼

#### 4. 칵테일 관리 (lib/drinkMgr.dart)

- **DrinkMgr**: 플립 애니메이션으로 두 뷰 전환
  - DrinkListPage: 칵테일 목록
  - RecipeEditPage: 선택된 칵테일의 레시피 편집

- **RecipeEditPage**:
  - 레시피 항목별 DropdownButton으로 재료 선택
  - TextField로 양 입력
  - 삭제는 로컬 상태(`deleted` 리스트)에 추가 후 커밋 시 일괄 처리
  - "완료" 버튼으로 `updateRecipe()` 및 `deleteRecipe()` API 호출

#### 5. 소셜 기능 (lib/social.dart)

- **Firebase 인증**: FlutterFire UI 사용 (Google 로그인)
- **SocialPage**:
  - 로그인 전: SignInScreen 표시
  - 로그인 후: 코멘트 작성 및 조회 가능
  - 평균 평점 계산 및 표시
  - 본인 코멘트만 삭제 가능 (UID 비교)

### API 통신

백엔드 URL: `https://alcohol.bada.works/api/`

- **GET 엔드포인트**:
  - `/drinks/?format=json`: 모든 칵테일 조회
  - `/bases/?format=json`: 모든 재료 조회
  - `/comments/?search={drink_idx}`: 특정 칵테일의 코멘트 조회 (인증 필요)

- **POST 엔드포인트**:
  - `/postdrink/`: 칵테일 추가
  - `/postbase/`: 재료 추가
  - `/postrecipe/`: 레시피 항목 추가
  - `/comments/`: 코멘트 추가 (인증 필요)

- **PATCH 엔드포인트**:
  - `/postbase/{idx}/`: 재료 업데이트
  - `/postrecipe/{idx}/`: 레시피 항목 업데이트

- **DELETE 엔드포인트**:
  - `/postrecipe/{idx}/`: 레시피 항목 삭제
  - `/comments/{idx}/`: 코멘트 삭제 (인증 필요)

### Firebase 설정

Firebase 인증이 `lib/main.dart`의 `main()` 함수에서 초기화됩니다.
**주의**: Firebase API 키가 코드에 하드코딩되어 있습니다 (프로젝트 ID: `alcohol-bada`).

### 중요한 상태 관리 패턴

- **GlobalKey 사용**: 부모 위젯에서 자식 State에 접근
  - `AlcoholAdmin`에서 `BaseMgrState`와 `DrinkMgrState`의 GlobalKey 유지
  - BottomSheet에서 항목 추가 시 `currentState?.addBase()` 또는 `currentState?.addDrink()` 호출

- **Future 기반 데이터 로딩**:
  - `initState()`에서 `fetchDrink()`, `fetchBase()`, `fetchComment()` 호출
  - `.then()` 콜백에서 `setState()` 호출하여 UI 업데이트

- **StreamBuilder**:
  - `SocialPage`에서 `FirebaseAuth.instance.authStateChanges()` 스트림 구독
  - 인증 상태 변경 시 자동으로 UI 전환

### 코드 작성 시 주의사항

1. **한글 UI**: 사용자 대면 텍스트는 한글로 작성 (예: "추가", "완료", "재고 여부", "평균 평점")

2. **이미지 처리**:
   - 칵테일 이미지가 없으면 기본 이미지 사용: `https://cdn.erniea.net/ethanol.png`
   - lib/drink.dart:83-86 참조

3. **재고 필터링 로직**:
   - `Recipe.available`은 모든 `RecipeElement`의 `base.inStock`이 true일 때만 true
   - 메인 화면의 칵테일 필터링은 `Drink.recipe.available` 체크
   - SelectPage는 `inStock`이 true인 재료만 표시

4. **UTF-8 디코딩**:
   - 모든 HTTP 응답은 `utf8.decode(response.bodyBytes)` 사용 (한글 지원)

5. **인증 헤더**:
   - 코멘트 관련 API는 `Authorization` 헤더에 Firebase ID 토큰 필요
   - `await FirebaseAuth.instance.currentUser?.getIdToken()` 사용
