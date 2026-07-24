import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { GlassWater, Home, Wine } from 'lucide-react'
import BasesTab from '../components/admin/BasesTab'
import DrinksTab from '../components/admin/DrinksTab'

export default function AdminPage() {
  const navigate = useNavigate()
  const [tab, setTab] = useState<0 | 1>(0)

  return (
    <div className="flex h-full flex-col bg-neutral-50 text-neutral-900 dark:bg-neutral-950 dark:text-neutral-100">
      {/* 앱바 */}
      <header className="flex shrink-0 items-center gap-2 border-b border-neutral-200 px-4 py-3 dark:border-neutral-800">
        <h1 className="text-xl font-bold">{tab === 0 ? '재료 관리' : '칵테일 관리'}</h1>
        <div className="flex-1" />
        <button
          onClick={() => navigate('/')}
          title="메인으로"
          className="rounded-full p-2 text-neutral-500 hover:bg-neutral-100 dark:hover:bg-neutral-800"
        >
          <Home size={20} />
        </button>
      </header>

      {/* 본문 */}
      <main className="min-h-0 flex-1">{tab === 0 ? <BasesTab /> : <DrinksTab />}</main>

      {/* 하단 탭바 */}
      <nav className="shrink-0 border-t border-neutral-200 bg-white dark:border-neutral-800 dark:bg-neutral-900">
        <div className="mx-auto flex max-w-xl">
          <TabButton active={tab === 0} onClick={() => setTab(0)} icon={<Wine size={22} />} label="재료" />
          <TabButton active={tab === 1} onClick={() => setTab(1)} icon={<GlassWater size={22} />} label="칵테일" />
        </div>
      </nav>
    </div>
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
      <span className={`rounded-full px-5 py-1 ${active ? 'bg-brand/15' : ''}`}>{icon}</span>
      {label}
    </button>
  )
}
