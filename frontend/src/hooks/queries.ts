import { useQuery } from '@tanstack/react-query'
import { fetchBases, fetchDrinks } from '../api/client'

export function useDrinks() {
  return useQuery({
    queryKey: ['drinks'],
    queryFn: fetchDrinks,
    staleTime: 1000 * 60 * 5, // 5분간 캐시 유지
  })
}

export function useBases() {
  return useQuery({
    queryKey: ['bases'],
    queryFn: fetchBases,
    staleTime: 1000 * 60 * 5,
  })
}
