import type { Identity } from "@dfinity/agent"
import { call } from "@/services/client"
import type { TxView, WalletBalance, WalletDeposit } from "@/services/client"

export type { TxView, WalletBalance, WalletDeposit }

export function registerWallet(identity: Identity | undefined) {
  return call(identity, "Register wallet failed", (actor) => actor.registerWallet())
}

export function loadDeposit(identity: Identity | undefined) {
  return call(identity, "Deposit info failed", (actor) => actor.depositInfo())
}

export function loadBalance(identity: Identity | undefined) {
  return call(identity, "Balance failed", (actor) => actor.getBalance())
}

export function proposeTransfer(
  identity: Identity | undefined,
  transferId: string,
  toPrincipal: string,
  amount: bigint,
) {
  return call(identity, "Preview failed", (actor) =>
    actor.proposeTransfer(transferId, toPrincipal, amount),
  )
}

export function executeTransfer(
  identity: Identity | undefined,
  transferId: string,
  toPrincipal: string,
  amount: bigint,
) {
  return call(identity, "Transfer failed", (actor) =>
    actor.executeTransfer(transferId, toPrincipal, amount),
  )
}

export function sendTransfer(
  identity: Identity | undefined,
  transferId: string,
  toPrincipal: string,
  amount: bigint,
) {
  return executeTransfer(identity, transferId, toPrincipal, amount)
}

export function loadTransactions(identity: Identity | undefined, offset = 0, limit = 20) {
  return call(identity, "History failed", (actor) =>
    actor.listTransactions(BigInt(offset), BigInt(limit)),
  )
}

export function formatTokenAmount(amount: bigint, decimals: number) {
  const base = 10n ** BigInt(decimals)
  const whole = amount / base
  const frac = amount % base
  const fracText = frac.toString().padStart(decimals, "0").replace(/0+$/, "")
  return fracText.length > 0 ? `${whole}.${fracText}` : whole.toString()
}

export function parseTokenAmount(text: string, decimals: number) {
  const trimmed = text.trim()
  if (!trimmed) return null
  const [whole, frac = ""] = trimmed.split(".")
  if (!/^\d+$/.test(whole) || (frac && !/^\d+$/.test(frac))) return null
  const fracPadded = (frac + "0".repeat(decimals)).slice(0, decimals)
  return BigInt(whole) * 10n ** BigInt(decimals) + BigInt(fracPadded || "0")
}
