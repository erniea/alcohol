import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { auth } from '../lib/firebase'
import { getIdToken } from './auth'
import {
  deleteComment as apiDeleteComment,
  fetchComments,
  postComment,
} from '../api/client'

export function useComments(drinkIdx: number, enabled: boolean) {
  return useQuery({
    queryKey: ['comments', drinkIdx],
    queryFn: async () => fetchComments(drinkIdx, await getIdToken()),
    enabled,
  })
}

export function useAddComment(drinkIdx: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (v: { star: number; comment: string }) =>
      postComment(
        { drink: drinkIdx, uid: auth.currentUser!.uid, star: v.star, comment: v.comment },
        await getIdToken(),
      ),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['comments', drinkIdx] }),
  })
}

export function useDeleteComment(drinkIdx: number) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (idx: number) => apiDeleteComment(idx, await getIdToken()),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['comments', drinkIdx] }),
  })
}
