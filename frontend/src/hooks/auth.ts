import { useEffect, useState } from 'react'
import { onAuthStateChanged, type User } from 'firebase/auth'
import { auth } from '../lib/firebase'

/** Firebase 인증 상태 구독 */
export function useAuth() {
  const [user, setUser] = useState<User | null>(auth.currentUser)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    return onAuthStateChanged(auth, (u) => {
      setUser(u)
      setLoading(false)
    })
  }, [])

  return { user, loading }
}

/** 현재 사용자의 ID 토큰 (인증 헤더용) */
export async function getIdToken(): Promise<string> {
  const t = await auth.currentUser?.getIdToken()
  if (!t) throw new Error('로그인이 필요합니다')
  return t
}
