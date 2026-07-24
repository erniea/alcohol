import {
  parseBase,
  parseComment,
  parseDrink,
  type Base,
  type Comment,
  type Drink,
} from './types'

// 개발 환경에서는 Vite 프록시(/api)를 통해 CORS를 우회하고,
// 프로덕션 빌드에서는 백엔드 절대 URL을 직접 호출한다.
export const API_BASE = import.meta.env.DEV ? '/api' : 'https://alcohol.bada.works/api'

/** 이미지가 없는 칵테일에 사용할 기본 이미지 */
export const DEFAULT_DRINK_IMAGE = 'https://cdn.erniea.net/ethanol.png'

async function getJson(url: string, init?: RequestInit): Promise<any> {
  const res = await fetch(url, init)
  if (!res.ok) {
    throw new Error(`요청 실패 (${res.status}): ${url}`)
  }
  return res.json()
}

// DRF 페이지네이션 응답({count,next,previous,results})과 순수 배열 응답을 모두 지원
function asArray(j: any): any[] {
  if (Array.isArray(j)) return j
  return j?.results ?? []
}

// --- 조회 ---

export async function fetchDrinks(): Promise<Drink[]> {
  const j = await getJson(`${API_BASE}/drinks/?format=json`)
  return asArray(j).map(parseDrink)
}

export async function fetchBases(): Promise<Base[]> {
  const j = await getJson(`${API_BASE}/bases/?format=json`)
  return asArray(j).map(parseBase)
}

/** 특정 칵테일의 코멘트 조회 (인증 필요) */
export async function fetchComments(drinkIdx: number, idToken: string): Promise<Comment[]> {
  const j = await getJson(`${API_BASE}/comments/?search=${drinkIdx}`, {
    headers: { Authorization: idToken },
  })
  return asArray(j).map(parseComment)
}

// --- 코멘트 작성/삭제 (인증 필요) ---

export async function postComment(
  body: { drink: number; star: number; comment: string },
  idToken: string,
): Promise<void> {
  await getJson(`${API_BASE}/comments/`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: idToken },
    body: JSON.stringify(body),
  })
}

export async function deleteComment(idx: number, idToken: string): Promise<void> {
  const res = await fetch(`${API_BASE}/comments/${idx}/`, {
    method: 'DELETE',
    headers: { Authorization: idToken },
  })
  if (!res.ok) throw new Error(`코멘트 삭제 실패 (${res.status})`)
}
