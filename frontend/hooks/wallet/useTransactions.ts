"use client"

import { useCallback, useEffect, useState } from "react"
import type { Identity } from "@dfinity/agent"
import { loadTransactions, type TxView } from "@/services/wallet/wallet"

export function useTransactions(identity: Identity | undefined) {
  const [items, setItems] = useState<TxView[]>([])
  const [error, setError] = useState("")
  const [loading, setLoading] = useState(false)

  const refresh = useCallback(async () => {
    if (!identity) {
      setItems([])
      return
    }
    setLoading(true)
    setError("")
    const result = await loadTransactions(identity)
    setLoading(false)
    if (!result.ok) {
      setError(result.error)
      return
    }
    if (result.data.ok) {
      setItems(result.data.ok.items)
    } else {
      setError(result.data.err?.message ?? "History unavailable")
    }
  }, [identity])

  useEffect(() => {
    refresh()
  }, [refresh])

  return { items, error, loading, refresh }
}
