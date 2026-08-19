"use client"

import useSWR from "swr"
import { pingBackend } from "@/services/health/health"

export function useBackendHealth() {
  return useSWR(
    "backend-health",
    async () => {
      const result = await pingBackend()
      if (!result.ok) throw new Error(result.error)
      return result.data
    },
    { refreshInterval: 15000, revalidateOnFocus: true },
  )
}
