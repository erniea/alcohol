import { X } from 'lucide-react'

interface Props {
  title: string
  onClose: () => void
  children: React.ReactNode
}

export default function Modal({ title, onClose, children }: Props) {
  return (
    <div className="fixed inset-0 z-40 flex items-center justify-center p-4">
      <div className="absolute inset-0 bg-black/50" onClick={onClose} />
      <div className="relative w-full max-w-md rounded-3xl bg-white p-6 shadow-xl dark:bg-neutral-900">
        <div className="mb-4 flex items-center justify-between">
          <h2 className="text-lg font-bold">{title}</h2>
          <button
            onClick={onClose}
            className="rounded-full p-1.5 text-neutral-400 hover:bg-neutral-100 dark:hover:bg-neutral-800"
          >
            <X size={20} />
          </button>
        </div>
        {children}
      </div>
    </div>
  )
}
