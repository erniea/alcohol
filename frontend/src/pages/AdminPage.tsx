import { ArrowLeft } from 'lucide-react'
import { useNavigate } from 'react-router-dom'

export default function AdminPage() {
  const navigate = useNavigate()
  return (
    <div className="flex h-full flex-col items-center justify-center gap-4 bg-neutral-50 text-neutral-500 dark:bg-neutral-950">
      <p>관리자 화면은 준비 중입니다</p>
      <button
        onClick={() => navigate('/')}
        className="flex items-center gap-2 rounded-xl bg-brand px-4 py-2 text-white"
      >
        <ArrowLeft size={18} /> 돌아가기
      </button>
    </div>
  )
}
