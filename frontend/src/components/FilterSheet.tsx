import { CircleCheck, SlidersHorizontal, Wine, X } from 'lucide-react'
import type { Base } from '../api/types'

interface Props {
  open: boolean
  onClose: () => void
  bases: Base[]
  selected: Set<number>
  onToggle: (idx: number) => void
  onClear: () => void
}

export default function FilterSheet({
  open,
  onClose,
  bases,
  selected,
  onToggle,
  onClear,
}: Props) {
  if (!open) return null

  const inStock = bases.filter((b) => b.inStock)

  return (
    <div className="fixed inset-0 z-30 flex flex-col justify-end">
      {/* 배경 딤 */}
      <div className="absolute inset-0 bg-black/50" onClick={onClose} />

      {/* 시트 */}
      <div className="relative max-h-[85vh] w-full max-w-xl self-center rounded-t-3xl bg-white dark:bg-neutral-900">
        <div className="mx-auto mt-3 h-1 w-10 rounded-full bg-neutral-300 dark:bg-neutral-600" />

        {/* 헤더 */}
        <div className="flex items-center gap-4 px-6 py-4">
          <div className="rounded-xl bg-brand/15 p-2.5 text-brand">
            <SlidersHorizontal size={22} />
          </div>
          <div className="min-w-0 flex-1">
            <h2 className="text-lg font-bold text-neutral-900 dark:text-neutral-100">
              재료 필터
            </h2>
            <p className="text-xs text-neutral-500">보유한 재료를 선택하세요</p>
          </div>
          {selected.size > 0 && (
            <button
              onClick={onClear}
              className="flex items-center gap-1 rounded-lg px-2 py-1 text-sm text-brand"
            >
              <X size={16} /> 초기화
            </button>
          )}
          <button
            onClick={onClose}
            className="rounded-full p-1.5 text-neutral-500 hover:bg-neutral-100 dark:hover:bg-neutral-800"
          >
            <X size={20} />
          </button>
        </div>

        <div className="border-t border-neutral-200 dark:border-neutral-800" />

        {/* 재료 목록 */}
        <div className="max-h-[55vh] overflow-y-auto p-4">
          {inStock.length === 0 ? (
            <p className="py-12 text-center text-neutral-500">
              재고가 있는 재료가 없습니다
            </p>
          ) : (
            <ul className="space-y-2">
              {inStock.map((base) => {
                const isSel = selected.has(base.idx)
                return (
                  <li key={base.idx}>
                    <button
                      onClick={() => onToggle(base.idx)}
                      className={`flex w-full items-center gap-3 rounded-2xl border-2 p-3 text-left transition-colors ${
                        isSel
                          ? 'border-brand bg-brand/10'
                          : 'border-transparent bg-neutral-100 dark:bg-neutral-800'
                      }`}
                    >
                      <span
                        className={`flex h-10 w-10 items-center justify-center rounded-xl ${
                          isSel
                            ? 'bg-brand text-white'
                            : 'bg-neutral-200 text-neutral-500 dark:bg-neutral-700'
                        }`}
                      >
                        <Wine size={20} />
                      </span>
                      <span
                        className={`flex-1 font-medium ${
                          isSel
                            ? 'font-semibold text-neutral-900 dark:text-neutral-100'
                            : 'text-neutral-700 dark:text-neutral-300'
                        }`}
                      >
                        {base.name}
                      </span>
                      {isSel && <CircleCheck size={20} className="text-brand" />}
                    </button>
                  </li>
                )
              })}
            </ul>
          )}
        </div>

        {/* 하단 통계 */}
        {selected.size > 0 && (
          <div className="flex items-center justify-center gap-2 bg-brand/10 p-4 text-brand">
            <CircleCheck size={20} />
            <span className="font-semibold">{selected.size}개의 재료 선택됨</span>
          </div>
        )}
      </div>
    </div>
  )
}
