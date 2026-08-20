"use client"

import { useCallback, useEffect, useState } from "react"
import type { Identity } from "@dfinity/agent"
import { formatTokenAmount, loadBalance, type WalletBalance } from "@/services/wallet/wallet"

export function useBalance(identity: Identity | undefined) {
  const [balance, setBalance] = useState<WalletBalance | null>(null)
  const [error, setError] = useState("")
  const [loading, setLoading] = useState(false)

  const refresh = useCallback(async () => {
    if (!identity) {
      setBalance(null)
      return
    }
    setLoading(true)
    setError("")
    const result = await loadBalance(identity)
    setLoading(false)
    if (!result.ok) {
      setError(result.error)
      return
    }
    if (result.data.ok) {
      setBalance(result.data.ok)
    } else {
      setError(result.data.err?.message ?? "Balance unavailable")
    }
  }, [identity])

  useEffect(() => {
    refresh()
  }, [refresh])

  const display = balance
    ? `${formatTokenAmount(balance.amount, Number(balance.decimals))} ${balance.symbol}`
    : "—"

  return { balance, display, error, loading, refresh }
}
