# Alcohol - 칵테일 레시피 관리 앱

React로 개발된 칵테일 레시피 관리 및 평가 웹 앱입니다.
(원래 Flutter 앱이었으나 웹 성능을 위해 React SPA로 마이그레이션되었습니다.)

## 주요 기능

- 🍸 칵테일 레시피 조회 (전체화면 세로 스와이프 + 3D 플립 카드)
- 🔎 이름 검색 및 보유 재료 기반 필터
- 💬 Firebase Google 로그인 기반 평점·코멘트
- 👨‍💼 관리자 모드 (재료/칵테일/레시피 편집, 이미지 업로드)
- 🌙 라이트/다크 모드

## 기술 스택

- **React + Vite + TypeScript** (SPA)
- **Tailwind CSS v4**
- **TanStack Query** — 서버 상태/캐싱
- **Firebase Web SDK** — Google 로그인
- **lucide-react**, **react-router-dom**

백엔드(Django REST, `alcohol.bada.works/api`)와 Firebase 프로젝트는 그대로 재사용합니다.

## 시작하기

```bash
cd frontend
npm install
npm run dev      # http://localhost:5173 (개발 서버, /api 는 백엔드로 프록시)
```

Firebase 웹 설정은 공개 식별자라 `frontend/src/lib/firebase.ts`에 인라인되어 있습니다.
(Firebase 콘솔의 승인된 도메인에 배포 도메인이 등록되어 있어야 로그인이 됩니다.)

## 빌드 & 배포

```bash
# 저장소 루트에서
./scripts/deploy_web.sh    # 빌드 + rsync로 서버 배포
```

또는 수동으로:
```bash
cd frontend
npm run build              # → frontend/dist
```

정적 SPA이므로 nginx 등에서 없는 경로를 index.html로 폴백해야 합니다:
```nginx
location / { try_files $uri $uri/ /index.html; }
```

## 프로젝트 구조

```
frontend/
├── src/
│   ├── api/          # 타입/파서(types), 조회·코멘트(client), 관리자 API(admin)
│   ├── lib/          # firebase 초기화
│   ├── hooks/        # queries, auth, comments, admin (TanStack Query)
│   ├── pages/        # DrinksPage, AdminPage
│   └── components/   # DrinkCard, DrinksFeed, FilterSheet, SocialPanel, admin/*
scripts/
├── build_web.sh      # React 빌드
└── deploy_web.sh     # 빌드 + rsync 배포
```

자세한 아키텍처와 API 계약은 [CLAUDE.md](./CLAUDE.md)를 참고하세요.

## 라이선스

개인 프로젝트입니다.
