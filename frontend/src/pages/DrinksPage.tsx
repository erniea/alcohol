import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  MessageCircle,
  Martini,
  RefreshCw,
  Search,
  Settings,
  SlidersHorizontal,
  X,
} from 'lucide-react'
import DrinksFeed from '../components/DrinksFeed'
import FilterSheet from '../components/FilterSheet'
import SocialPanel from '../components/SocialPanel'
import { useBases, useDrinks } from '../hooks/queries'
import { recipeAvailable, type Drink } from '../api/types'

export default function DrinksPage() {
  const navigate = useNavigate()
  const { data: drinks, isLoading, isError, refetch } = useDrinks()
  const { data: bases } = useBases()

  const [tab, setTab] = useState<0 | 1>(0)
  const [search, setSearch] = useState('')
  const [baseFilter, setBaseFilter] = useState<Set<number>>(new Set())
  const [sheetOpen, setSheetOpen] = useState(false)
  const [currentDrink, setCurrentDrink] = useState<Drink | null>(null)

  // 원본 filteredDrinks 로직과 동일:
  // - 이름 검색
  // - 재료 선택 시: 선택 재료를 모두 포함하는 칵테일
  // - 재료 미선택 시: 제조 가능한(재고 완비) 칵테일만
  const filtered = useMemo(() => {
    if (!drinks) return []
    const q = search.trim().toLowerCase()
    return drinks.filter((d) => {
      if (q && !d.name.toLowerCase().includes(q)) return false
      if (baseFilter.size > 0) {
        return [...baseFilter].every((idx) =>
          d.recipe.some((el) => el.base.idx === idx),
        )
      }
      // 검색 중에는 제조 불가(재료 부족) 칵테일도 표시
      if (q) return true
      // 기본(검색·필터 없음): 제조 가능한 것만
      return recipeAvailable(d.recipe)
    })
  }, [drinks, search, baseFilter])

  const selectedBases = useMemo(
    () => (bases ?? []).filter((b) => baseFilter.has(b.idx)),
    [bases, baseFilter],
  )

  const toggleBase = (idx: number) =>
    setBaseFilter((prev) => {
      const next = new Set(prev)
      next.has(idx) ? next.delete(idx) : next.add(idx)
      return next
    })

  const clearFilters = () => {
    setBaseFilter(new Set())
    setSearch('')
  }

  return (
    <div className="flex h-full flex-col bg-neutral-50 text-neutral-900 dark:bg-neutral-950 dark:text-neutral-100">
      {/* 앱바 */}
      <header className="shrink-0 border-b border-neutral-200 dark:border-neutral-800">
        <div className="mx-auto flex max-w-xl items-center gap-2 px-4 py-3">
          <h1 className="text-xl font-bold">{tab === 0 ? '칵테일' : '평가'}</h1>
          <div className="flex-1" />
          {tab === 0 && (
            <IconBtn title="새로고침" onClick={() => refetch()}>
              <RefreshCw size={20} />
            </IconBtn>
          )}
          <IconBtn title="관리자 모드" onClick={() => navigate('/admin')}>
            <Settings size={20} />
          </IconBtn>
        </div>

        {/* 검색 + 필터 (칵테일 탭에서만) */}
        {tab === 0 && (
          <div className="mx-auto flex max-w-xl flex-col gap-3 px-4 pb-3">
            <div className="flex items-center gap-2">
              <div className="flex flex-1 items-center gap-2 rounded-2xl bg-neutral-100 px-3 dark:bg-neutral-800">
                <Search size={18} className="text-neutral-400" />
                <input
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  placeholder="칵테일 이름 검색..."
                  className="w-full bg-transparent py-3 outline-none"
                />
                {search && (
                  <button onClick={() => setSearch('')} className="text-neutral-400">
                    <X size={18} />
                  </button>
                )}
              </div>
              <button
                onClick={() => setSheetOpen(true)}
                className={`relative rounded-2xl p-3 ${
                  baseFilter.size > 0
                    ? 'bg-brand/15 text-brand'
                    : 'bg-neutral-100 text-neutral-500 dark:bg-neutral-800'
                }`}
                title="필터"
              >
                <SlidersHorizontal size={20} />
                {baseFilter.size > 0 && (
                  <span className="absolute -top-1 -right-1 flex h-5 min-w-5 items-center justify-center rounded-full bg-brand px-1 text-xs font-bold text-white">
                    {baseFilter.size}
                  </span>
                )}
              </button>
            </div>

            {/* 선택된 필터 칩 */}
            {selectedBases.length > 0 && (
              <div className="flex gap-2 overflow-x-auto pb-1">
                {selectedBases.map((b) => (
                  <button
                    key={b.idx}
                    onClick={() => toggleBase(b.idx)}
                    className="flex shrink-0 items-center gap-1.5 rounded-full bg-brand/15 px-3 py-1.5 text-sm font-medium text-brand"
                  >
                    {b.name}
                    <X size={14} />
                  </button>
                ))}
                <button
                  onClick={clearFilters}
                  className="shrink-0 rounded-full px-3 py-1.5 text-sm text-neutral-500"
                >
                  초기화
                </button>
              </div>
            )}
          </div>
        )}
      </header>

      {/* 본문 */}
      <main className="min-h-0 flex-1">
        {/* 칵테일 목록은 항상 마운트해 스크롤 위치를 보존하고, 평가 탭에서는 숨김만 처리 */}
        <div className={`h-full ${tab === 0 ? '' : 'hidden'}`}>
            {isLoading && <Centered>불러오는 중…</Centered>}
            {isError && (
              <Centered>
                <p className="mb-3">오류가 발생했습니다</p>
                <button
                  onClick={() => refetch()}
                  className="rounded-xl bg-brand px-4 py-2 text-white"
                >
                  다시 시도
                </button>
              </Centered>
            )}
            {drinks && filtered.length === 0 && (
              <Centered>
                <Martini size={56} className="mb-4 text-neutral-300" />
                {baseFilter.size > 0 || search
                  ? '조건에 맞는 칵테일이 없습니다'
                  : '제조 가능한 칵테일이 없습니다'}
              </Centered>
            )}
            {filtered.length > 0 && (
              <DrinksFeed drinks={filtered} onCurrentChange={setCurrentDrink} />
            )}
        </div>
        {tab === 1 &&
          (currentDrink ? (
            <SocialPanel key={currentDrink.idx} drink={currentDrink} />
          ) : (
            <EvalPlaceholder />
          ))}
      </main>

      {/* 하단 탭바 */}
      <nav className="shrink-0 border-t border-neutral-200 bg-white dark:border-neutral-800 dark:bg-neutral-900">
        <div className="mx-auto flex max-w-xl">
          <TabButton
            active={tab === 0}
            onClick={() => setTab(0)}
            icon={<Martini size={22} />}
            label="칵테일"
          />
          <TabButton
            active={tab === 1}
            onClick={() => setTab(1)}
            icon={<MessageCircle size={22} />}
            label="평가"
          />
        </div>
      </nav>

      <FilterSheet
        open={sheetOpen}
        onClose={() => setSheetOpen(false)}
        bases={bases ?? []}
        selected={baseFilter}
        onToggle={toggleBase}
        onClear={() => setBaseFilter(new Set())}
      />
    </div>
  )
}

function IconBtn({
  children,
  title,
  onClick,
}: {
  children: React.ReactNode
  title: string
  onClick: () => void
}) {
  return (
    <button
      onClick={onClick}
      title={title}
      className="rounded-full p-2 text-neutral-500 hover:bg-neutral-100 dark:hover:bg-neutral-800"
    >
      {children}
    </button>
  )
}

function TabButton({
  active,
  onClick,
  icon,
  label,
}: {
  active: boolean
  onClick: () => void
  icon: React.ReactNode
  label: string
}) {
  return (
    <button
      onClick={onClick}
      className={`flex flex-1 flex-col items-center gap-1 py-2.5 text-xs font-medium ${
        active ? 'text-brand' : 'text-neutral-400'
      }`}
    >
      <span
        className={`rounded-full px-5 py-1 ${active ? 'bg-brand/15' : ''}`}
      >
        {icon}
      </span>
      {label}
    </button>
  )
}

function EvalPlaceholder() {
  return (
    <Centered>
      <MessageCircle size={56} className="mb-4 text-neutral-300" />
      칵테일을 선택해주세요
    </Centered>
  )
}

function Centered({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-full flex-col items-center justify-center px-4 text-center text-neutral-500">
      {children}
    </div>
  )
}
