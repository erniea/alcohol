import { useEffect, useRef } from 'react'
import DrinkCard from './DrinkCard'
import type { Drink } from '../api/types'

interface Props {
  drinks: Drink[]
  onCurrentChange?: (drink: Drink | null) => void
}

/**
 * 원본 Flutter의 세로 PageView를 CSS scroll-snap으로 재현.
 * 카드 1개가 화면을 꽉 채우고, 위/아래 스와이프로 전환된다.
 * 네이티브 스크롤이라 별도 애니메이션 비용 없이 매끄럽다.
 */
export default function DrinksFeed({ drinks, onCurrentChange }: Props) {
  const containerRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const root = containerRef.current
    if (!root || !onCurrentChange) return

    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            const idx = Number((entry.target as HTMLElement).dataset.idx)
            onCurrentChange(drinks[idx] ?? null)
          }
        }
      },
      { root, threshold: 0.6 },
    )

    const sections = root.querySelectorAll('[data-idx]')
    sections.forEach((s) => observer.observe(s))
    return () => observer.disconnect()
  }, [drinks, onCurrentChange])

  return (
    <div
      ref={containerRef}
      className="h-full snap-y snap-mandatory overflow-y-auto"
    >
      {drinks.map((d, i) => (
        <section
          key={d.idx}
          data-idx={i}
          className="flex h-full snap-start snap-always items-center justify-center p-4"
        >
          <DrinkCard drink={d} />
        </section>
      ))}
    </div>
  )
}
