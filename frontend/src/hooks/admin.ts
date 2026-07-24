import { useMutation, useQueryClient } from '@tanstack/react-query'
import * as admin from '../api/admin'

/** 재료 목록과 (재고 변동 시) 칵테일 목록을 무효화 */
function useInvalidate() {
  const qc = useQueryClient()
  return {
    bases: () => qc.invalidateQueries({ queryKey: ['bases'] }),
    drinks: () => qc.invalidateQueries({ queryKey: ['drinks'] }),
  }
}

export function useAddBase() {
  const inv = useInvalidate()
  return useMutation({
    mutationFn: (v: { name: string; inStock: boolean }) =>
      admin.addBase(v.name, v.inStock),
    onSuccess: inv.bases,
  })
}

export function useUpdateBaseName() {
  const inv = useInvalidate()
  return useMutation({
    mutationFn: (v: { idx: number; name: string }) =>
      admin.updateBaseName(v.idx, v.name),
    onSuccess: inv.bases,
  })
}

export function useUpdateBaseInStock() {
  const inv = useInvalidate()
  return useMutation({
    mutationFn: (v: { idx: number; inStock: boolean }) =>
      admin.updateBaseInStock(v.idx, v.inStock),
    onSuccess: () => {
      inv.bases()
      inv.drinks() // 재고가 바뀌면 제조 가능 여부도 갱신
    },
  })
}

export function useAddDrink() {
  const inv = useInvalidate()
  return useMutation({
    mutationFn: (v: { name: string; desc: string; img: string; file?: File }) =>
      admin.addDrink(v.name, v.desc, v.img).then(async (drink) => {
        if (v.file) await admin.uploadDrinkImage(drink.idx, v.file)
        return drink
      }),
    onSuccess: inv.drinks,
  })
}

export function useSaveRecipe() {
  const inv = useInvalidate()
  return useMutation({
    // 추가/수정/삭제를 한 번에 커밋
    mutationFn: async (v: {
      drinkIdx: number
      added: { base: number; volume: string }[]
      updated: { idx: number; base: number; volume: string }[]
      deleted: number[]
    }) => {
      await Promise.all([
        ...v.added.map((a) => admin.addRecipe(v.drinkIdx, a.base, a.volume)),
        ...v.updated.map((u) => admin.updateRecipe(u.idx, u.base, u.volume)),
        ...v.deleted.map((idx) => admin.deleteRecipe(idx)),
      ])
    },
    onSuccess: inv.drinks,
  })
}

export function useUploadDrinkImage() {
  const inv = useInvalidate()
  return useMutation({
    mutationFn: (v: { drinkIdx: number; file: File }) =>
      admin.uploadDrinkImage(v.drinkIdx, v.file),
    onSuccess: inv.drinks,
  })
}
