# CLAUDE.md

이 파일은 이 저장소에서 작업하는 Claude Code에게 지침을 제공합니다.

## 프로젝트 개요

칵테일 레시피 관리 웹 앱입니다. 사용자는 보유 재료(base)에 따라 칵테일을 필터링하고,
레시피를 조회하며, Firebase 인증으로 평점·코멘트를 남길 수 있습니다. 관리자 화면에서
재료/칵테일/레시피를 편집하고 이미지를 업로드합니다.

원래 Flutter로 개발됐으나 웹 로딩/렌더링 성능 문제로 **React 웹 네이티브 SPA로
마이그레이션**되었습니다. (Flutter 코드는 제거됨. 필요 시 git 히스토리 참고.)

## 기술 스택

- **React + Vite + TypeScript** (SPA, `frontend/`)
- **Tailwind CSS v4** (`@tailwindcss/vite`)
- **TanStack Query** — 서버 상태/캐싱
- **Firebase Web SDK** — Google 로그인 (프로젝트: `alcohol-bada`)
- **lucide-react** — 아이콘
- **react-router-dom** — 라우팅 (`/`, `/admin`)

백엔드(Django REST, `alcohol.bada.works/api`)와 Firebase 프로젝트, nginx 정적
호스팅은 그대로 재사용합니다. 백엔드는 이 저장소에 없습니다.

## 개발 명령어

모든 프론트엔드 작업은 `frontend/`에서 수행합니다.

```bash
cd frontend
npm install
npm run dev        # 개발 서버 (http://localhost:5173, /api 는 백엔드로 프록시)
npm run build      # 프로덕션 빌드 → frontend/dist
npm run lint       # 린트
```

배포 (저장소 루트에서):
```bash
./scripts/deploy_web.sh   # 빌드 + rsync로 서버 배포 (스크립트 상단 SERVER_* 확인)
```

## 코드 구조 (`frontend/src`)

- `api/types.ts` — Drink/Base/RecipeElement/Comment 타입 + JSON 파서
  - **주의**: 백엔드 JSON은 재고 필드가 `instock`(소문자). 파서에서 `inStock`으로 매핑.
  - `recipeAvailable(recipe)` — 모든 재료가 재고에 있을 때 true.
- `api/client.ts` — 조회/코멘트 fetch 래퍼. `API_BASE`는 dev에서 `/api`(프록시),
  prod에서 `https://alcohol.bada.works/api`.
- `api/admin.ts` — 관리자 API(재료/칵테일/레시피 CRUD, 이미지 업로드). **인증 불필요.**
  - 이미지 업로드: 브라우저 canvas로 긴 변 1200px 리사이즈 → JPEG multipart PATCH.
- `lib/firebase.ts` — Firebase 초기화 + Google 로그인. (웹 config는 공개 식별자라 인라인)
- `hooks/` — `queries`(drinks/bases), `auth`, `comments`, `admin` mutation 훅.
- `pages/DrinksPage.tsx` — 메인. 전체화면 세로 스와이프(CSS scroll-snap) + 검색/필터
  바텀시트 + 하단 탭(칵테일/평가).
- `pages/AdminPage.tsx` — 재료/칵테일 관리 두 탭.
- `components/` — `DrinkCard`(CSS 3D 플립), `DrinksFeed`, `FilterSheet`, `SocialPanel`,
  `admin/*`.

## API 계약 (백엔드)

베이스 URL: `https://alcohol.bada.works/api`

- `GET /drinks/?format=json`, `GET /bases/?format=json` — **DRF 페이지네이션**
  (`{count,next,previous,results}`). `asArray()`로 `results` 추출.
- `GET /comments/?search={drinkIdx}` — 코멘트 조회. 헤더 `Authorization: <idToken>` 필요.
- `POST /comments/` — `{drink, uid, star, comment}`, 토큰 필요.
- `DELETE /comments/{idx}/` — 토큰 필요.
- `POST /postbase/` `{name, instock:"true"/"false"}`, `PATCH /postbase/{idx}/` `{name}` 또는 `{instock}`.
- `POST /postdrink/` `{name, img, desc}`.
- `POST /postrecipe/` `{drink, base, volume}`, `PATCH /postrecipe/{idx}/` `{base, volume}`, `DELETE /postrecipe/{idx}/`.
- `PATCH /upload-image/{drinkIdx}/` — multipart, 필드명 `img`.

## 필터 로직 (원본과 동일하게 유지)

- 이름 검색: `name` 부분 일치.
- 재료 선택 시: 선택한 재료를 **모두 포함**하는 칵테일.
- 재료 미선택 시(기본): **제조 가능한(재고 완비)** 칵테일만 표시.

## 작성 시 주의사항

1. **한글 UI**: 사용자 대면 텍스트는 한글.
2. **기본 이미지**: 이미지 없거나 로드 실패 시 `DEFAULT_DRINK_IMAGE`(CDN) 폴백.
3. **인증 범위**: 코멘트만 Firebase 토큰 필요. 관리자 API는 인증 없음.
4. **이미지 정리**: 업로드 시 서버가 기존 파일을 삭제하지 않아 orphan이 쌓임(백엔드 이슈).
5. **배포**: SPA이므로 nginx에 `try_files $uri $uri/ /index.html` 폴백 필요.
