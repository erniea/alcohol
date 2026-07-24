import { useState } from 'react'
import { LogOut, Star, Trash2 } from 'lucide-react'
import type { Drink } from '../api/types'
import { useAuth } from '../hooks/auth'
import { useAddComment, useComments, useDeleteComment } from '../hooks/comments'
import { signInWithGoogle, signOut } from '../lib/firebase'

export default function SocialPanel({ drink }: { drink: Drink }) {
  const { user, loading } = useAuth()

  if (loading) {
    return <Centered>불러오는 중…</Centered>
  }

  if (!user) {
    return <SignIn />
  }

  return <CommentsView drink={drink} uid={user.uid} />
}

function SignIn() {
  const [error, setError] = useState('')
  return (
    <Centered>
      <p className="mb-6 text-neutral-600 dark:text-neutral-300">
        평가를 남기려면 로그인이 필요합니다
      </p>
      <button
        onClick={() =>
          signInWithGoogle().catch((e) => setError(e.message ?? String(e)))
        }
        className="flex items-center gap-3 rounded-xl border border-neutral-300 bg-white px-5 py-3 font-medium text-neutral-800 shadow-sm hover:bg-neutral-50 dark:border-neutral-700 dark:bg-neutral-800 dark:text-neutral-100 dark:hover:bg-neutral-700"
      >
        <GoogleG />
        Google로 로그인
      </button>
      {error && <p className="mt-4 text-sm text-red-500">{error}</p>}
    </Centered>
  )
}

function CommentsView({ drink, uid }: { drink: Drink; uid: string }) {
  const { data: comments, isLoading, isError } = useComments(drink.idx, true)
  const addComment = useAddComment(drink.idx)
  const deleteComment = useDeleteComment(drink.idx)

  const [star, setStar] = useState(5)
  const [text, setText] = useState('')

  const avg =
    comments && comments.length > 0
      ? Math.round(comments.reduce((s, c) => s + c.star, 0) / comments.length)
      : 0

  const submit = () => {
    if (!text.trim()) return
    addComment.mutate(
      { star, comment: text.trim() },
      { onSuccess: () => setText('') },
    )
  }

  return (
    <div className="mx-auto flex h-full max-w-xl flex-col">
      {/* 헤더 */}
      <div className="flex items-center gap-3 px-4 py-3">
        <h2 className="flex-1 truncate text-lg font-bold">{drink.name}</h2>
        {comments && comments.length > 0 && (
          <div className="flex items-center gap-1 text-sm text-neutral-500">
            <Stars count={avg} size={16} />
            <span className="ml-1">평균 {avg}</span>
          </div>
        )}
        <button
          onClick={() => signOut()}
          title="로그아웃"
          className="rounded-full p-2 text-neutral-400 hover:bg-neutral-100 dark:hover:bg-neutral-800"
        >
          <LogOut size={18} />
        </button>
      </div>

      {/* 코멘트 목록 */}
      <div className="min-h-0 flex-1 space-y-3 overflow-y-auto px-4 pb-4">
        {isLoading && <p className="py-8 text-center text-neutral-500">불러오는 중…</p>}
        {isError && (
          <p className="py-8 text-center text-neutral-500">
            코멘트를 불러올 수 없습니다
          </p>
        )}
        {comments && comments.length === 0 && (
          <p className="py-8 text-center text-neutral-500">
            아직 평가가 없습니다. 첫 평가를 남겨보세요!
          </p>
        )}
        {comments?.map((c) => (
          <div
            key={c.idx}
            className="rounded-2xl bg-neutral-100 p-4 dark:bg-neutral-800"
          >
            <div className="flex items-center">
              <Stars count={c.star} size={16} />
              <div className="flex-1" />
              {c.uid === uid && (
                <button
                  onClick={() => deleteComment.mutate(c.idx)}
                  className="text-neutral-400 hover:text-red-500"
                  title="삭제"
                >
                  <Trash2 size={16} />
                </button>
              )}
            </div>
            {c.comment && (
              <p className="mt-2 text-sm text-neutral-700 dark:text-neutral-200">
                {c.comment}
              </p>
            )}
          </div>
        ))}
      </div>

      {/* 작성 폼 */}
      <div className="border-t border-neutral-200 p-4 dark:border-neutral-800">
        <div className="mb-2 flex justify-center gap-1">
          {[1, 2, 3, 4, 5].map((i) => (
            <button key={i} onClick={() => setStar(i)} className="p-1">
              <Star
                size={26}
                className={
                  i <= star
                    ? 'fill-amber-400 text-amber-400'
                    : 'text-neutral-300 dark:text-neutral-600'
                }
              />
            </button>
          ))}
        </div>
        <div className="flex gap-2">
          <input
            value={text}
            onChange={(e) => setText(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && submit()}
            placeholder="평가를 입력하세요..."
            className="flex-1 rounded-xl bg-neutral-100 px-4 py-2.5 outline-none focus:ring-2 focus:ring-brand dark:bg-neutral-800"
          />
          <button
            onClick={submit}
            disabled={addComment.isPending || !text.trim()}
            className="rounded-xl bg-brand px-5 py-2.5 font-semibold text-white disabled:opacity-50"
          >
            등록
          </button>
        </div>
        {addComment.isError && (
          <p className="mt-2 text-sm text-red-500">
            등록 실패: {(addComment.error as Error).message}
          </p>
        )}
      </div>
    </div>
  )
}

function Stars({ count, size }: { count: number; size: number }) {
  return (
    <span className="inline-flex">
      {Array.from({ length: count }).map((_, i) => (
        <Star key={i} size={size} className="fill-amber-400 text-amber-400" />
      ))}
    </span>
  )
}

function GoogleG() {
  return (
    <svg width="18" height="18" viewBox="0 0 48 48" aria-hidden>
      <path
        fill="#EA4335"
        d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"
      />
      <path
        fill="#4285F4"
        d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"
      />
      <path
        fill="#FBBC05"
        d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"
      />
      <path
        fill="#34A853"
        d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"
      />
    </svg>
  )
}

function Centered({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-full flex-col items-center justify-center px-4 text-center">
      {children}
    </div>
  )
}
