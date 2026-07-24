// 백엔드 JSON 구조에 맞춘 타입 및 파서
// (기존 Flutter lib/models/* 와 동일한 필드. 단, base 재고 필드는 JSON에서 `instock`)

export interface Base {
  idx: number
  name: string
  inStock: boolean
}

export interface RecipeElement {
  idx: number
  base: Base
  volume: string
}

export interface Drink {
  idx: number
  name: string
  desc: string
  img: string
  recipe: RecipeElement[]
}

export interface Comment {
  idx: number
  uid: string
  star: number
  comment: string
}

/** 레시피의 모든 재료가 재고에 있으면 true (재료가 없으면 false) */
export function recipeAvailable(recipe: RecipeElement[]): boolean {
  if (recipe.length === 0) return false
  return recipe.every((e) => e.base.inStock)
}

// --- JSON 파서 ---

export function parseBase(j: any): Base {
  return { idx: j.idx, name: j.name ?? '', inStock: j.instock ?? false }
}

export function parseRecipeElement(j: any): RecipeElement {
  return { idx: j.idx, base: parseBase(j.base), volume: j.volume ?? '' }
}

export function parseDrink(j: any): Drink {
  return {
    idx: j.idx,
    name: j.name ?? '',
    desc: j.desc ?? '',
    img: j.img ?? '',
    recipe: (j.recipe ?? []).map(parseRecipeElement),
  }
}

export function parseComment(j: any): Comment {
  return { idx: j.idx, uid: j.uid ?? '', star: j.star ?? 0, comment: j.comment ?? '' }
}
