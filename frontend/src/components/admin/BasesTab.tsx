import { useState } from 'react'
import { Plus, Wine } from 'lucide-react'
import { useBases } from '../../hooks/queries'
import {
  useAddBase,
  useUpdateBaseInStock,
  useUpdateBaseName,
} from '../../hooks/admin'
import Modal from './Modal'

export default function BasesTab() {
  const { data: bases, isLoading } = useBases()
  const updateName = useUpdateBaseName()
  const updateStock = useUpdateBaseInStock()
  const [adding, setAdding] = useState(false)

  return (
    <div className="relative h-full overflow-y-auto p-4">
      {isLoading && <p className="py-8 text-center text-neutral-500">불러오는 중…</p>}

      <ul className="mx-auto max-w-xl space-y-3">
        {bases?.map((base) => (
          <li
            key={base.idx}
            className="flex items-center gap-3 rounded-2xl bg-white p-3 shadow-sm dark:bg-neutral-900"
          >
            <span
              className={`flex h-10 w-10 items-center justify-center rounded-full ${
                base.inStock
                  ? 'bg-brand/15 text-brand'
                  : 'bg-neutral-200 text-neutral-400 dark:bg-neutral-700'
              }`}
            >
              <Wine size={20} />
            </span>
            <input
              defaultValue={base.name}
              className="flex-1 bg-transparent font-medium outline-none"
              onBlur={(e) => {
                const v = e.target.value.trim()
                if (v && v !== base.name) updateName.mutate({ idx: base.idx, name: v })
              }}
              onKeyDown={(e) => e.key === 'Enter' && e.currentTarget.blur()}
            />
            <div className="flex flex-col items-end">
              <Toggle
                on={base.inStock}
                onChange={(v) => updateStock.mutate({ idx: base.idx, inStock: v })}
              />
              <span
                className={`mt-1 text-xs ${
                  base.inStock ? 'text-brand' : 'text-neutral-400'
                }`}
              >
                {base.inStock ? '재고 있음' : '재고 없음'}
              </span>
            </div>
          </li>
        ))}
      </ul>

      <button
        onClick={() => setAdding(true)}
        className="fixed right-6 bottom-24 flex items-center gap-2 rounded-full bg-brand px-5 py-3 font-semibold text-white shadow-lg"
      >
        <Plus size={20} /> 재료 추가
      </button>

      {adding && <AddBaseModal onClose={() => setAdding(false)} />}
    </div>
  )
}

function AddBaseModal({ onClose }: { onClose: () => void }) {
  const addBase = useAddBase()
  const [name, setName] = useState('')
  const [inStock, setInStock] = useState(true)

  const submit = () => {
    if (!name.trim()) return
    addBase.mutate(
      { name: name.trim(), inStock },
      { onSuccess: onClose },
    )
  }

  return (
    <Modal title="새 재료 추가" onClose={onClose}>
      <input
        autoFocus
        value={name}
        onChange={(e) => setName(e.target.value)}
        onKeyDown={(e) => e.key === 'Enter' && submit()}
        placeholder="예: 보드카, 럼, 진 등"
        className="w-full rounded-xl border border-neutral-300 px-4 py-3 outline-none focus:ring-2 focus:ring-brand dark:border-neutral-700 dark:bg-neutral-800"
      />
      <label className="mt-4 flex items-center justify-between">
        <span>재고 여부</span>
        <Toggle on={inStock} onChange={setInStock} />
      </label>
      <div className="mt-6 flex justify-end gap-2">
        <button onClick={onClose} className="px-4 py-2 text-neutral-500">
          취소
        </button>
        <button
          onClick={submit}
          disabled={addBase.isPending || !name.trim()}
          className="rounded-xl bg-brand px-4 py-2 font-semibold text-white disabled:opacity-50"
        >
          추가
        </button>
      </div>
    </Modal>
  )
}

function Toggle({ on, onChange }: { on: boolean; onChange: (v: boolean) => void }) {
  return (
    <button
      type="button"
      onClick={() => onChange(!on)}
      className={`inline-flex h-6 w-11 shrink-0 items-center rounded-full p-0.5 transition-colors ${
        on ? 'bg-brand' : 'bg-neutral-300 dark:bg-neutral-600'
      }`}
    >
      <span
        className={`h-5 w-5 rounded-full bg-white shadow transition-transform ${
          on ? 'translate-x-5' : 'translate-x-0'
        }`}
      />
    </button>
  )
}
