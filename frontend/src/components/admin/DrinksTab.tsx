import { useRef, useState } from 'react'
import { ImagePlus, Plus } from 'lucide-react'
import { DEFAULT_DRINK_IMAGE } from '../../api/client'
import type { Drink } from '../../api/types'
import { useDrinks } from '../../hooks/queries'
import { useAddDrink } from '../../hooks/admin'
import Modal from './Modal'
import RecipeEditModal from './RecipeEditModal'

export default function DrinksTab() {
  const { data: drinks, isLoading } = useDrinks()
  const [editing, setEditing] = useState<Drink | null>(null)
  const [adding, setAdding] = useState(false)

  return (
    <div className="relative h-full overflow-y-auto p-4">
      {isLoading && <p className="py-8 text-center text-neutral-500">불러오는 중…</p>}

      <ul className="mx-auto max-w-xl space-y-3">
        {drinks?.map((drink) => (
          <li key={drink.idx}>
            <button
              onClick={() => setEditing(drink)}
              className="flex w-full items-center gap-3 rounded-2xl bg-white p-3 text-left shadow-sm dark:bg-neutral-900"
            >
              <img
                src={drink.img || DEFAULT_DRINK_IMAGE}
                alt=""
                className="h-14 w-14 rounded-xl object-cover"
                onError={(e) => {
                  ;(e.currentTarget as HTMLImageElement).src = DEFAULT_DRINK_IMAGE
                }}
              />
              <div className="min-w-0 flex-1">
                <p className="truncate font-semibold">{drink.name}</p>
                <p className="text-sm text-neutral-500">
                  재료 {drink.recipe.length}개
                </p>
              </div>
            </button>
          </li>
        ))}
      </ul>

      <button
        onClick={() => setAdding(true)}
        className="fixed right-6 bottom-24 flex items-center gap-2 rounded-full bg-brand px-5 py-3 font-semibold text-white shadow-lg"
      >
        <Plus size={20} /> 칵테일 추가
      </button>

      {editing && (
        <RecipeEditModal drink={editing} onClose={() => setEditing(null)} />
      )}
      {adding && <AddDrinkModal onClose={() => setAdding(false)} />}
    </div>
  )
}

function AddDrinkModal({ onClose }: { onClose: () => void }) {
  const addDrink = useAddDrink()
  const fileRef = useRef<HTMLInputElement>(null)
  const [name, setName] = useState('')
  const [desc, setDesc] = useState('')
  const [file, setFile] = useState<File | null>(null)

  const submit = () => {
    if (!name.trim()) return
    addDrink.mutate(
      { name: name.trim(), desc: desc.trim(), img: '', file: file ?? undefined },
      { onSuccess: onClose },
    )
  }

  return (
    <Modal title="새 칵테일 추가" onClose={onClose}>
      <div className="space-y-3">
        <input
          autoFocus
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="칵테일 이름"
          className="w-full rounded-xl border border-neutral-300 px-4 py-3 outline-none focus:ring-2 focus:ring-brand dark:border-neutral-700 dark:bg-neutral-800"
        />
        <textarea
          value={desc}
          onChange={(e) => setDesc(e.target.value)}
          placeholder="설명 (선택)"
          rows={2}
          className="w-full resize-none rounded-xl border border-neutral-300 px-4 py-3 outline-none focus:ring-2 focus:ring-brand dark:border-neutral-700 dark:bg-neutral-800"
        />
        <button
          onClick={() => fileRef.current?.click()}
          className="flex w-full items-center justify-center gap-2 rounded-xl border border-dashed border-neutral-300 py-3 text-sm text-neutral-500 dark:border-neutral-600"
        >
          <ImagePlus size={18} />
          {file ? file.name : '이미지 선택 (선택)'}
        </button>
        <input
          ref={fileRef}
          type="file"
          accept="image/*"
          hidden
          onChange={(e) => setFile(e.target.files?.[0] ?? null)}
        />
      </div>

      {addDrink.isError && (
        <p className="mt-2 text-sm text-red-500">
          추가 실패: {(addDrink.error as Error).message}
        </p>
      )}

      <div className="mt-6 flex justify-end gap-2">
        <button onClick={onClose} className="px-4 py-2 text-neutral-500">
          취소
        </button>
        <button
          onClick={submit}
          disabled={addDrink.isPending || !name.trim()}
          className="rounded-xl bg-brand px-4 py-2 font-semibold text-white disabled:opacity-50"
        >
          {addDrink.isPending ? '추가 중…' : '추가'}
        </button>
      </div>
    </Modal>
  )
}
