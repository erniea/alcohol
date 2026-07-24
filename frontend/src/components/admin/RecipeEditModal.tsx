import { useEffect, useRef, useState } from 'react'
import { ImagePlus, Plus, Trash2 } from 'lucide-react'
import { DEFAULT_DRINK_IMAGE } from '../../api/client'
import type { Drink } from '../../api/types'
import { useBases } from '../../hooks/queries'
import { useSaveRecipe, useUploadDrinkImage } from '../../hooks/admin'
import Modal from './Modal'

interface Row {
  key: number
  idx: number | null // 기존 레시피 idx, 신규면 null
  base: number
  volume: string
}

let nextKey = 1

export default function RecipeEditModal({
  drink,
  onClose,
}: {
  drink: Drink
  onClose: () => void
}) {
  const { data: bases } = useBases()
  const saveRecipe = useSaveRecipe()
  const uploadImage = useUploadDrinkImage()
  const fileRef = useRef<HTMLInputElement>(null)

  const [rows, setRows] = useState<Row[]>(() =>
    drink.recipe.map((e) => ({
      key: nextKey++,
      idx: e.idx,
      base: e.base.idx,
      volume: e.volume,
    })),
  )
  const [deleted, setDeleted] = useState<number[]>([])
  // 새로 고른 이미지의 로컬 미리보기 (업로드 후에도 즉시 반영)
  const [previewUrl, setPreviewUrl] = useState<string | null>(null)
  useEffect(() => {
    return () => {
      if (previewUrl) URL.revokeObjectURL(previewUrl)
    }
  }, [previewUrl])

  const addRow = () => {
    const firstBase = bases?.[0]?.idx ?? 0
    setRows((r) => [...r, { key: nextKey++, idx: null, base: firstBase, volume: '' }])
  }

  const removeRow = (key: number) => {
    setRows((r) => {
      const target = r.find((x) => x.key === key)
      if (target?.idx != null) setDeleted((d) => [...d, target.idx!])
      return r.filter((x) => x.key !== key)
    })
  }

  const patchRow = (key: number, patch: Partial<Row>) =>
    setRows((r) => r.map((x) => (x.key === key ? { ...x, ...patch } : x)))

  const save = () => {
    saveRecipe.mutate(
      {
        drinkIdx: drink.idx,
        added: rows.filter((r) => r.idx == null).map((r) => ({ base: r.base, volume: r.volume })),
        updated: rows
          .filter((r) => r.idx != null)
          .map((r) => ({ idx: r.idx!, base: r.base, volume: r.volume })),
        deleted,
      },
      { onSuccess: onClose },
    )
  }

  const onPickImage = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return
    setPreviewUrl((prev) => {
      if (prev) URL.revokeObjectURL(prev)
      return URL.createObjectURL(file)
    })
    uploadImage.mutate({ drinkIdx: drink.idx, file })
  }

  const imgSrc = previewUrl || drink.img || DEFAULT_DRINK_IMAGE

  return (
    <Modal title={`${drink.name} 레시피`} onClose={onClose}>
      {/* 현재 이미지 미리보기 (탭하여 변경) */}
      <button
        onClick={() => fileRef.current?.click()}
        disabled={uploadImage.isPending}
        className="relative mb-4 block h-40 w-full overflow-hidden rounded-2xl bg-neutral-100 disabled:opacity-70 dark:bg-neutral-800"
      >
        <img
          src={imgSrc}
          alt={drink.name}
          className="h-full w-full object-cover"
          onError={(e) => {
            ;(e.currentTarget as HTMLImageElement).src = DEFAULT_DRINK_IMAGE
          }}
        />
        <div className="absolute inset-x-0 bottom-0 flex items-center justify-center gap-1.5 bg-black/50 py-2 text-sm text-white">
          <ImagePlus size={16} />
          {uploadImage.isPending ? '업로드 중…' : '이미지 변경'}
        </div>
      </button>
      <input
        ref={fileRef}
        type="file"
        accept="image/*"
        hidden
        onChange={onPickImage}
      />
      {uploadImage.isError && (
        <p className="mb-2 text-sm text-red-500">
          이미지 업로드 실패: {(uploadImage.error as Error).message}
        </p>
      )}

      {/* 재료 목록 */}
      <div className="max-h-[45vh] space-y-2 overflow-y-auto">
        {rows.map((row) => (
          <div key={row.key} className="flex items-center gap-2">
            <select
              value={row.base}
              onChange={(e) => patchRow(row.key, { base: Number(e.target.value) })}
              className="min-w-0 flex-1 rounded-lg border border-neutral-300 bg-white px-2 py-2 dark:border-neutral-700 dark:bg-neutral-800"
            >
              {bases?.map((b) => (
                <option key={b.idx} value={b.idx}>
                  {b.name}
                </option>
              ))}
            </select>
            <input
              value={row.volume}
              onChange={(e) => patchRow(row.key, { volume: e.target.value })}
              placeholder="용량"
              className="w-24 rounded-lg border border-neutral-300 px-2 py-2 dark:border-neutral-700 dark:bg-neutral-800"
            />
            <button
              onClick={() => removeRow(row.key)}
              className="shrink-0 p-2 text-neutral-400 hover:text-red-500"
            >
              <Trash2 size={18} />
            </button>
          </div>
        ))}
      </div>

      <button
        onClick={addRow}
        className="mt-2 flex w-full items-center justify-center gap-1 rounded-xl border border-neutral-200 py-2 text-sm text-neutral-600 dark:border-neutral-700 dark:text-neutral-300"
      >
        <Plus size={16} /> 재료 추가
      </button>

      {saveRecipe.isError && (
        <p className="mt-2 text-sm text-red-500">
          저장 실패: {(saveRecipe.error as Error).message}
        </p>
      )}

      <div className="mt-6 flex justify-end gap-2">
        <button onClick={onClose} className="px-4 py-2 text-neutral-500">
          취소
        </button>
        <button
          onClick={save}
          disabled={saveRecipe.isPending}
          className="rounded-xl bg-brand px-4 py-2 font-semibold text-white disabled:opacity-50"
        >
          {saveRecipe.isPending ? '저장 중…' : '완료'}
        </button>
      </div>
    </Modal>
  )
}
