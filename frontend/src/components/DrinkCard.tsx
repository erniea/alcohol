import { useState } from 'react'
import { Check, CircleCheck, CircleX, Hand, Martini, X } from 'lucide-react'
import { DEFAULT_DRINK_IMAGE } from '../api/client'
import { recipeAvailable, type Drink } from '../api/types'

export default function DrinkCard({ drink }: { drink: Drink }) {
  const [flipped, setFlipped] = useState(false)
  const available = recipeAvailable(drink.recipe)

  return (
    <div
      className="mx-auto h-full w-full max-w-xl cursor-pointer select-none"
      style={{ perspective: 1200 }}
      onClick={() => setFlipped((f) => !f)}
    >
      <div
        className="relative h-full w-full transition-transform duration-500"
        style={{
          transformStyle: 'preserve-3d',
          transform: flipped ? 'rotateY(180deg)' : 'rotateY(0deg)',
          transitionTimingFunction: 'cubic-bezier(0.4, 0, 0.2, 1)',
        }}
      >
        {/* 앞면 */}
        <div
          className="absolute inset-0 overflow-hidden rounded-3xl shadow-lg"
          style={{ backfaceVisibility: 'hidden' }}
        >
          <CardFront drink={drink} available={available} />
        </div>

        {/* 뒷면 (레시피) */}
        <div
          className="absolute inset-0 overflow-hidden rounded-3xl bg-white shadow-lg dark:bg-neutral-900"
          style={{ backfaceVisibility: 'hidden', transform: 'rotateY(180deg)' }}
        >
          <CardBack drink={drink} available={available} />
        </div>
      </div>
    </div>
  )
}

function CardFront({ drink, available }: { drink: Drink; available: boolean }) {
  return (
    <>
      <img
        src={drink.img || DEFAULT_DRINK_IMAGE}
        alt={drink.name}
        loading="lazy"
        className="absolute inset-0 h-full w-full object-cover"
        onError={(e) => {
          ;(e.currentTarget as HTMLImageElement).src = DEFAULT_DRINK_IMAGE
        }}
      />
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-black/70" />

      {/* 정보 패널 (glassmorphism) */}
      <div className="absolute inset-x-5 bottom-5 rounded-2xl border border-white/20 bg-black/35 p-5 backdrop-blur-sm">
        <h2 className="line-clamp-2 text-2xl font-bold text-white">{drink.name}</h2>
        {drink.desc && (
          <p className="mt-2 line-clamp-2 text-sm text-white/90">{drink.desc}</p>
        )}
        <div className="mt-3 flex items-center">
          <AvailabilityBadge available={available} />
          <div className="flex-1" />
          <span className="flex h-9 w-9 items-center justify-center rounded-full bg-white/20 text-white">
            <Hand size={18} />
          </span>
        </div>
      </div>
    </>
  )
}

function CardBack({ drink, available }: { drink: Drink; available: boolean }) {
  return (
    <div className="flex h-full flex-col p-7">
      <div className="mb-6 flex items-center gap-4">
        <div className="rounded-2xl bg-brand/15 p-3 text-brand">
          <Martini size={24} />
        </div>
        <div className="min-w-0">
          <p className="text-xs font-medium tracking-widest text-neutral-500 uppercase">
            Recipe
          </p>
          <h2 className="truncate text-xl font-bold text-neutral-900 dark:text-neutral-100">
            {drink.name}
          </h2>
        </div>
      </div>

      <ul className="flex-1 space-y-3 overflow-y-auto">
        {drink.recipe.map((el) => {
          const ok = el.base.inStock
          return (
            <li
              key={el.idx}
              className={`flex items-center gap-4 rounded-2xl border p-4 ${
                ok
                  ? 'border-brand/30 bg-brand/10'
                  : 'border-neutral-200 bg-neutral-100 dark:border-neutral-700 dark:bg-neutral-800'
              }`}
            >
              <span
                className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-white ${
                  ok ? 'bg-brand' : 'bg-neutral-400'
                }`}
              >
                {ok ? <Check size={16} /> : <X size={16} />}
              </span>
              <span
                className={`flex-1 font-semibold ${
                  ok
                    ? 'text-neutral-900 dark:text-neutral-100'
                    : 'text-neutral-500 line-through'
                }`}
              >
                {el.base.name}
              </span>
              <span
                className={`rounded-xl px-3 py-1.5 text-sm font-bold ${
                  ok
                    ? 'bg-brand/15 text-brand'
                    : 'bg-neutral-200 text-neutral-500 dark:bg-neutral-700'
                }`}
              >
                {el.volume}
              </span>
            </li>
          )
        })}
      </ul>

      <div
        className={`mt-5 flex items-center justify-center gap-2 rounded-2xl p-4 font-bold text-white ${
          available ? 'bg-brand' : 'bg-red-600'
        }`}
      >
        {available ? <CircleCheck size={22} /> : <CircleX size={22} />}
        <span>{available ? '제조 가능합니다' : '재료가 부족합니다'}</span>
      </div>
      <p className="mt-3 text-center text-xs text-neutral-400">탭하여 앞면 보기</p>
    </div>
  )
}

function AvailabilityBadge({ available }: { available: boolean }) {
  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-xl border px-3 py-1.5 text-xs font-semibold text-white ${
        available
          ? 'border-green-400/50 bg-green-500/30'
          : 'border-red-400/50 bg-red-500/30'
      }`}
    >
      {available ? <CircleCheck size={14} /> : <CircleX size={14} />}
      {available ? '제조 가능' : '재료 부족'}
    </span>
  )
}
