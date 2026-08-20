"use client"

import { useRef, useState } from "react"
import type { Identity } from "@dfinity/agent"
import { executeTransfer, parseTokenAmount, proposeTransfer } from "@/services/wallet/wallet"

export function useSendTransfer(identity: Identity | undefined, decimals = 8) {
  const [sending, setSending] = useState(false)
  const [error, setError] = useState("")
  const [message, setMessage] = useState("")
  const transferIdRef = useRef("")

  async function preview(toPrincipal: string, amountText: string) {
    if (!identity) {
      setError("Login required")
      return false
    }
    const amount = parseTokenAmount(amountText, decimals)
    if (amount === null || amount <= 0n) {
      setError("Enter a valid amount")
      return false
    }
    setError("")
    transferIdRef.current = crypto.randomUUID()
    const result = await proposeTransfer(
      identity,
      transferIdRef.current,
      toPrincipal,
      amount,
    )
    if (!result.ok) {
      setError(result.error)
      return false
    }
    if (result.data.err) {
      setError(result.data.err.message)
      return false
    }
    return true
  }

  async function execute(toPrincipal: string, amountText: string) {
    if (!identity) {
      setError("Login required")
      return false
    }
    const amount = parseTokenAmount(amountText, decimals)
    if (amount === null || amount <= 0n) {
      setError("Enter a valid amount")
      return false
    }
    setSending(true)
    setError("")
    setMessage("")
    const transferId = transferIdRef.current || crypto.randomUUID()
    const result = await executeTransfer(identity, transferId, toPrincipal, amount)
    setSending(false)
    if (!result.ok) {
      setError(result.error)
      return false
    }
    if (result.data.err) {
      setError(result.data.err.message)
      return false
    }
    setMessage(`Sent — block ${result.data.ok?.blockIndex.toString() ?? ""}`)
    transferIdRef.current = ""
    return true
  }

  return { sending, error, message, preview, execute, clear: () => { setError(""); setMessage("") } }
}
