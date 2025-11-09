# 전면 개편 계획

## 개편 목표
- UI/UX 현대화
- Riverpod을 통한 아키텍처 개선
- 성능 및 최적화
- 우선순위: 사용자 화면 (AlcoholDrinks)

## 1단계: 프로젝트 기반 구조 개선 (Foundation) ✅ 완료

### 1.1 의존성 추가 및 업데이트 ✅
- [x] Riverpod 패키지 추가 (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`)
- [x] Material Design 3 적용 (`useMaterial3: true`)
- [x] SDK 버전 업데이트 (`>=3.0.0 <4.0.0`)
- [x] Firebase 패키지 최신화 (`firebase_ui_auth`, `firebase_ui_oauth_google`)

### 1.2 폴더 구조 재편 ✅
```
lib/
├── core/
│   ├── providers/        # Riverpod providers (service_providers.dart)
│   └── constants/        # 상수 (api_constants.dart, app_constants.dart, app_theme.dart)
├── models/              # 데이터 모델 (base.dart, drink.dart, recipe.dart, comment.dart)
├── services/            # API 서비스 레이어
│   ├── drink_service.dart
│   ├── base_service.dart
│   ├── comment_service.dart
│   └── recipe_service.dart
├── features/            # 기능별 모듈
│   ├── drinks/
│   │   ├── providers/   # drink_providers.dart, base_providers.dart
│   │   ├── widgets/     # drink_card.dart, filter_drawer.dart, recipe_page.dart
│   │   └── screens/     # drinks_screen_v2.dart
│   ├── admin/
│   │   ├── screens/     # admin_screen.dart
│   │   └── widgets/     # base_management.dart, drink_management.dart, recipe_edit_dialog.dart
│   └── social/          # social_page.dart, comment_card.dart
└── main.dart
```

- [x] core 폴더 구조 생성
- [x] models 폴더로 ds.dart 분리 (base.dart, drink.dart, recipe.dart, comment.dart)
- [x] services 폴더 생성 및 API 레이어 구축
- [x] features 폴더 구조 생성
- [x] 레거시 파일 정리 (ds.dart, drink.dart, social.dart, drinkMgr.dart, baseMgr.dart, select.dart 삭제)

## 2단계: 데이터 레이어 구축 ✅ 완료

### 2.1 API 서비스 분리 ✅
- [x] `DrinkService` 생성: fetchDrinks 구현
- [x] `BaseService` 생성: fetchBases, updateBase, addBase 구현
- [x] `CommentService` 생성: fetchComments, addComment, deleteComment 구현
- [x] `RecipeService` 생성: addRecipe, deleteRecipe, updateRecipe 구현
- [x] 에러 핸들링 및 try-catch 추가
- [x] API URL을 constants로 분리 (ApiConstants)

### 2.2 Riverpod Providers 생성 ✅
- [x] `drinkListProvider`: 칵테일 목록 (AsyncNotifierProvider)
- [x] `baseListProvider`: 재료 목록 (AsyncNotifierProvider)
- [x] `baseFilterProvider`: 재료 필터 상태 (NotifierProvider)
- [x] `textFilterProvider`: 텍스트 필터 상태 (NotifierProvider)
- [x] `filteredDrinksProvider`: 필터링된 칵테일 목록 (computed FutureProvider)
- [x] `currentDrinkProvider`: 현재 선택된 칵테일 (FutureProvider)
- [x] `currentDrinkIndexProvider`: 현재 칵테일 인덱스 (NotifierProvider)
- [x] `inStockBasesProvider`: 재고 있는 재료만 (FutureProvider)

## 3단계: 사용자 화면 (AlcoholDrinks) 개선 ✅ 완료

### 3.1 성능 최적화 ✅
- [x] `build()` 메서드에서 매번 필터링하는 로직을 Riverpod computed provider로 이동 (filteredDrinksProvider)
- [x] 불필요한 `setState()` 제거
- [x] `ConsumerWidget` / `ConsumerStatefulWidget`으로 전환
- [x] 이미지 로딩 상태 표시 (loadingBuilder, errorBuilder)

### 3.2 UI/UX 현대화 ✅

#### 검색 UX 개선 ✅
- [x] SearchBar 위젯을 화면 상단에 배치
- [x] 실시간 검색 필터링 (textFilterProvider)
- [ ] 검색 기록 저장 (SharedPreferences) - 미구현

#### 필터 UI 개선 ✅
- [x] FilterDrawer로 필터 UI 개선 (Drawer 사용)
- [x] 선택된 필터를 FilterChip으로 시각적 표시
- [x] 빠른 필터 초기화 버튼 (clear_all 아이콘)
- [x] 필터 개수 Badge 표시

#### 카드 디자인 개선 ✅
- [x] Material Design 3 스타일 적용
- [x] 이미지 로딩 상태 표시 (CircularProgressIndicator)
- [x] 카드 그림자 및 라운딩 개선
- [x] 재료 목록에 재고 상태 표시 (취소선)
- [ ] Hero 애니메이션 - 미구현

#### 페이지 구조 개선 ✅
- [x] 수평 PageView → NavigationBar로 변경
- [x] 칵테일 목록 / 평가(소셜) 탭 분리
- [x] IndexedStack으로 탭 상태 유지
- [x] 수직 PageView로 칵테일 스와이프

### 3.3 새로운 기능
- [x] 다크 모드 지원 (AppTheme.darkTheme)
- [ ] 무한 스크롤 또는 페이지네이션 - 미구현
- [ ] 즐겨찾기 기능 - 미구현
- [ ] 칵테일 공유 기능 - 미구현

## 4단계: 애니메이션 및 세부 개선

### 4.1 부드러운 전환
- [ ] 페이지 전환 애니메이션 개선 (go_router 검토)
- [ ] 필터 적용 시 리스트 애니메이션 (AnimatedList)
- [ ] Skeleton loader 추가 (로딩 중)
- [ ] 스와이프 제스처 개선

### 4.2 반응형 디자인
- [ ] 웹/태블릿에서 2단 레이아웃 (목록 + 상세)
- [ ] 화면 크기에 따른 적응형 UI (LayoutBuilder)
- [ ] 가로 모드 지원 개선

## 5단계: 테스트 및 최적화

### 5.1 테스트 작성
- [ ] Widget 테스트 추가
- [ ] 프로바이더 단위 테스트
- [ ] 서비스 레이어 테스트
- [ ] Integration 테스트

### 5.2 성능 최적화
- [ ] 성능 프로파일링 (DevTools)
- [ ] 메모리 누수 확인
- [ ] 빌드 크기 최적화
- [ ] API 호출 최적화 (캐싱, debouncing)

## 관리자 화면 개선 ✅ 완료

### Admin 화면 구조 ✅
- [x] NavigationBar로 탭 분리 (재료 관리 / 칵테일 관리)
- [x] BaseManagement 위젯: 재료 목록 관리
  - [x] 인라인 이름 편집 (TextFormField)
  - [x] 재고 스위치 토글
  - [x] 재료 추가 다이얼로그
  - [x] 실시간 칵테일 availability 업데이트 (drinkListProvider invalidate)
- [x] DrinkManagement 위젯: 칵테일 목록 관리
  - [x] 제조 가능 여부에 따른 색상 표시 (보라색/빨간색)
  - [x] RecipeEditDialog로 레시피 편집
- [x] RecipeEditDialog: 레시피 상세 편집
  - [x] 재료 선택 (DropdownButton)
  - [x] 용량 입력 (TextField)
  - [x] 재료 추가/삭제 기능

### 주요 버그 수정 ✅
- [x] Recipe.available을 final에서 동적 getter로 변경
  - 재료 재고 상태 변경 시 실시간으로 칵테일 제조 가능 여부 업데이트
- [x] Import 충돌 해결 (ds.dart → models/*.dart)
- [x] 레거시 파일 완전 삭제

## 구현 우선순위 (업데이트)

### ✅ Phase 1 (핵심 기반) - 완료
- [x] 1.1 의존성 추가 및 업데이트
- [x] 1.2 폴더 구조 재편
- [x] 2.1 API 서비스 분리
- [x] 2.2 Riverpod Providers 생성

### ✅ Phase 2 (UI 개선) - 완료
- [x] 3.1 성능 최적화
- [x] 3.2 UI/UX 현대화
  - [x] 페이지 구조 개선
  - [x] 검색 UX 개선
  - [x] 필터 UI 개선
  - [x] 카드 디자인 개선
- [x] 관리자 화면 현대화
- [x] 소셜 기능 마이그레이션

### Phase 3 (완성도) - 미구현
- [ ] 3.3 새로운 기능 (즐겨찾기, 공유, 무한 스크롤)
- [ ] 4.1 부드러운 전환 (Hero 애니메이션, AnimatedList)
- [ ] 4.2 반응형 디자인

### Phase 4 (품질) - 미구현
- [ ] 5.1 테스트 작성
- [ ] 5.2 성능 최적화 (프로파일링)

## 다음 단계 제안

### Phase 3 구현 제안
1. **즐겨찾기 기능**
   - SharedPreferences로 로컬 저장
   - 즐겨찾기 필터 추가
   - 하트 아이콘 토글

2. **무한 스크롤**
   - API 페이지네이션 지원 필요
   - infinite_scroll_pagination 패키지 사용

3. **Hero 애니메이션**
   - 칵테일 카드 → 상세 화면 전환 시 부드러운 애니메이션

4. **공유 기능**
   - share_plus 패키지로 칵테일 레시피 공유

### 보안 개선 ✅ 완료
- [x] Firebase API 키를 환경 변수로 분리
- [x] `.env` 파일 사용 (flutter_dotenv)
- [x] 민감 정보 보호
- [x] `.gitignore`에 `.env` 추가
- [x] `.env.example` 템플릿 생성
- [x] README.md 문서화

### 배포 및 CI/CD 제안
- [ ] GitHub Actions 설정
- [ ] 자동 빌드 및 테스트
- [ ] Firebase Hosting 또는 다른 플랫폼 배포

## 완료 요약

**Phase 1 & 2 + 보안 개선 완료! 🎉**

### 주요 성과

#### 아키텍처 및 성능
- ✅ 완전한 Riverpod 마이그레이션 (AsyncNotifier, FutureProvider)
- ✅ Feature-based 아키텍처로 재구성
- ✅ Service 레이어 패턴 적용 (API 로직 분리)
- ✅ Computed providers로 성능 최적화

#### UI/UX
- ✅ Material Design 3 적용 (Light/Dark 테마)
- ✅ 사용자 화면 현대화
  - NavigationBar 기반 탭 구조
  - SearchBar + FilterDrawer
  - FilterChips로 선택된 필터 표시
  - 수직 PageView로 칵테일 스와이프
- ✅ 관리자 화면 현대화
  - 인라인 편집 (재료 이름, 재고)
  - RecipeEditDialog
  - 실시간 availability 업데이트

#### 기능 개선
- ✅ 실시간 상태 업데이트 (재료 재고 ↔ 칵테일 제조 가능 여부)
- ✅ 평가 탭 동기화 (현재 보고 있는 칵테일의 평가 표시)
- ✅ 필터 변경 시 첫 페이지로 자동 이동

#### 코드 품질
- ✅ 레거시 코드 완전 제거 (ds.dart, drink.dart, social.dart 등)
- ✅ Import 충돌 해결
- ✅ Recipe.available을 동적 getter로 변경

#### 보안
- ✅ Firebase API 키 환경 변수 분리 (flutter_dotenv)
- ✅ `.env` 파일로 민감 정보 관리
- ✅ `.gitignore`에 `.env` 추가
- ✅ `.env.example` 템플릿 제공
- ✅ README.md 문서화 (설치 방법, 보안 가이드)

### 다음 개발 후보

1. **즐겨찾기 기능** (Phase 3)
   - SharedPreferences 사용
   - 즐겨찾기 필터

2. **Hero 애니메이션** (Phase 3)
   - 칵테일 카드 전환 효과

3. **CI/CD 구축**
   - GitHub Actions
   - 자동 테스트 및 빌드

앱의 핵심 기능은 모두 현대적인 아키텍처로 재구축되었으며, 보안, 성능, 사용자 경험이 크게 개선되었습니다!
