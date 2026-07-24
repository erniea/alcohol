import { initializeApp } from 'firebase/app'
import {
  GoogleAuthProvider,
  getAuth,
  signInWithPopup,
  signOut as fbSignOut,
} from 'firebase/auth'

// Firebase 웹 설정 — 공개용 식별자이므로 코드에 포함해도 안전
// (보안은 Firebase 규칙 + 승인된 도메인으로 강제됨. 기존 alcohol-bada 프로젝트 재사용)
const firebaseConfig = {
  apiKey: 'AIzaSyBjW3tGd88Z3VL5rJSuPfwPUsT5lzWrBzs',
  authDomain: 'alcohol-bada.firebaseapp.com',
  projectId: 'alcohol-bada',
  storageBucket: 'alcohol-bada.appspot.com',
  messagingSenderId: '920011687590',
  appId: '1:920011687590:web:818405bc02ec38a5111667',
  measurementId: 'G-40GSPC0MRH',
}

export const firebaseApp = initializeApp(firebaseConfig)
export const auth = getAuth(firebaseApp)

const googleProvider = new GoogleAuthProvider()

export function signInWithGoogle() {
  return signInWithPopup(auth, googleProvider)
}

export function signOut() {
  return fbSignOut(auth)
}
