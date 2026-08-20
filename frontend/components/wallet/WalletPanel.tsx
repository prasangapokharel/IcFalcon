"use client"

import { useCallback, useEffect, useState } from "react"
import { useAuth } from "@/components/auth/auth-provider"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { DepositCard } from "@/components/wallet/DepositCard"
import { SendForm } from "@/components/wallet/SendForm"
import { TxHistory } from "@/components/wallet/TxHistory"
import { useBalance } from "@/hooks/wallet/useBalance"
import { useTransactions } from "@/hooks/wallet/useTransactions"
import { loadDeposit, registerWallet, type WalletDeposit } from "@/services/wallet/wallet"

export function WalletPanel() {
  const { identity, principal, ready, login, logout } = useAuth()
  const { display, refresh: refreshBalance } = useBalance(identity)
  const { items, loading: txLoading, refresh: refreshTx } = useTransactions(identity)
  const [deposit, setDeposit] = useState<WalletDeposit | null>(null)
  const [status, setStatus] = useState("")

  const setupWallet = useCallback(async () => {
    if (!identity) return
    setStatus("")
    const reg = await registerWallet(identity)
    if (!reg.ok) {
      setStatus(reg.error)
      return
    }
    if (reg.data.err) {
      setStatus(reg.data.err.message)
      return
    }
    if (reg.data.ok) setDeposit(reg.data.ok)
    await refreshBalance()
    await refreshTx()
  }, [identity, refreshBalance, refreshTx])

  useEffect(() => {
    if (!identity) {
      setDeposit(null)
      return
    }
    loadDeposit(identity).then((result) => {
      if (result.ok && result.data.ok) {
        setDeposit(result.data.ok)
      } else {
        setupWallet()
      }
    })
  }, [identity, setupWallet])

  function onSent() {
    refreshBalance()
    refreshTx()
  }

  if (!ready) {
    return <p className="text-sm text-muted-foreground">Loading auth…</p>
  }

  if (!identity) {
    return (
      <Card className="max-w-lg">
        <CardHeader>
          <CardTitle>Wallet</CardTitle>
        </CardHeader>
        <CardContent className="flex flex-col gap-4">
          <p className="text-sm text-muted-foreground">Sign in with Internet Identity to use your wallet.</p>
          <Button type="button" onClick={login}>
            Login
          </Button>
        </CardContent>
      </Card>
    )
  }

  return (
    <div className="mx-auto flex w-full max-w-lg flex-col gap-6">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle>Wallet</CardTitle>
          <Button type="button" variant="ghost" size="sm" onClick={logout}>
            Logout
          </Button>
        </CardHeader>
        <CardContent className="flex flex-col gap-2">
          <p className="text-xs text-muted-foreground break-all">{principal}</p>
          <p className="text-2xl font-semibold">{display}</p>
          <Button type="button" variant="outline" size="sm" onClick={() => { refreshBalance(); refreshTx() }}>
            Refresh
          </Button>
          {status ? <p className="text-sm text-destructive">{status}</p> : null}
        </CardContent>
      </Card>

      <DepositCard deposit={deposit} />
      <SendForm identity={identity} onSent={onSent} />
      <TxHistory items={items} loading={txLoading} />
    </div>
  )
}
