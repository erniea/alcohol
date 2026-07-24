import { API_BASE } from './client'
import {
  parseBase,
  parseDrink,
  parseRecipeElement,
  type Base,
  type Drink,
  type RecipeElement,
} from './types'

// 관리자 API는 인증이 필요 없음 (원본과 동일)
const JSON_HEADERS = { 'Content-Type': 'application/json' }

async function req(url: string, init: RequestInit): Promise<Response> {
  const res = await fetch(url, init)
  if (!res.ok) throw new Error(`요청 실패 (${res.status})`)
  return res
}

// --- 재료(Base) ---
// instock은 원본과 동일하게 문자열 "true"/"false"로 전송

export async function addBase(name: string, inStock: boolean): Promise<Base> {
  const res = await req(`${API_BASE}/postbase/`, {
    method: 'POST',
    headers: JSON_HEADERS,
    body: JSON.stringify({ name, instock: String(inStock) }),
  })
  return parseBase(await res.json())
}

export async function updateBaseName(idx: number, name: string): Promise<void> {
  await req(`${API_BASE}/postbase/${idx}/`, {
    method: 'PATCH',
    headers: JSON_HEADERS,
    body: JSON.stringify({ name }),
  })
}

export async function updateBaseInStock(idx: number, inStock: boolean): Promise<void> {
  await req(`${API_BASE}/postbase/${idx}/`, {
    method: 'PATCH',
    headers: JSON_HEADERS,
    body: JSON.stringify({ instock: String(inStock) }),
  })
}

// --- 칵테일(Drink) ---

export async function addDrink(
  name: string,
  desc: string,
  img: string,
): Promise<Drink> {
  const res = await req(`${API_BASE}/postdrink/`, {
    method: 'POST',
    headers: JSON_HEADERS,
    body: JSON.stringify({ name, img, desc }),
  })
  return parseDrink(await res.json())
}

// --- 레시피(RecipeElement) ---

export async function addRecipe(
  drink: number,
  base: number,
  volume: string,
): Promise<RecipeElement> {
  const res = await req(`${API_BASE}/postrecipe/`, {
    method: 'POST',
    headers: JSON_HEADERS,
    body: JSON.stringify({ drink, base, volume }),
  })
  return parseRecipeElement(await res.json())
}

export async function updateRecipe(
  idx: number,
  base: number,
  volume: string,
): Promise<void> {
  await req(`${API_BASE}/postrecipe/${idx}/`, {
    method: 'PATCH',
    headers: JSON_HEADERS,
    body: JSON.stringify({ base, volume }),
  })
}

export async function deleteRecipe(idx: number): Promise<void> {
  await req(`${API_BASE}/postrecipe/${idx}/`, {
    method: 'DELETE',
    headers: JSON_HEADERS,
  })
}

// --- 이미지 업로드 (브라우저 canvas로 리사이즈 후 JPEG multipart PATCH) ---

const MAX_DIMENSION = 1200
const JPEG_QUALITY = 0.85

export async function uploadDrinkImage(drinkIdx: number, file: File): Promise<void> {
  const blob = await resizeToJpeg(file)
  const form = new FormData()
  form.append('img', blob, replaceExt(file.name, '.jpg'))
  await req(`${API_BASE}/upload-image/${drinkIdx}/`, {
    method: 'PATCH',
    body: form,
  })
}

/** 원본 이미지를 긴 변 MAX_DIMENSION 이하로 줄여 JPEG Blob으로 반환 */
function resizeToJpeg(file: File): Promise<Blob> {
  return new Promise((resolve, reject) => {
    const url = URL.createObjectURL(file)
    const img = new Image()
    img.onload = () => {
      URL.revokeObjectURL(url)
      const scale = Math.min(1, MAX_DIMENSION / Math.max(img.width, img.height))
      const w = Math.round(img.width * scale)
      const h = Math.round(img.height * scale)
      const canvas = document.createElement('canvas')
      canvas.width = w
      canvas.height = h
      const ctx = canvas.getContext('2d')
      if (!ctx) return reject(new Error('canvas 컨텍스트 생성 실패'))
      ctx.drawImage(img, 0, 0, w, h)
      canvas.toBlob(
        (blob) => (blob ? resolve(blob) : reject(new Error('이미지 인코딩 실패'))),
        'image/jpeg',
        JPEG_QUALITY,
      )
    }
    img.onerror = () => {
      URL.revokeObjectURL(url)
      reject(new Error('이미지 로드 실패'))
    }
    img.src = url
  })
}

function replaceExt(name: string, ext: string): string {
  const dot = name.lastIndexOf('.')
  const base = dot > 0 ? name.slice(0, dot) : name
  return base + ext
}
