"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import type { WalletDeposit } from "@/services/wallet/wallet"

type Props = {
  deposit: WalletDeposit | null
}

export function DepositCard({ deposit }: Props) {
  if (!deposit) return null

  const hex = deposit.accountIdHex

  async function copy() {
    await navigator.clipboard.writeText(hex)
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Deposit</CardTitle>
      </CardHeader>
      <CardContent className="flex flex-col gap-3">
        <p className="text-sm text-muted-foreground">
          Send ICP to this account ID (hex). Same address works for ICRC deposits.
        </p>
        <code className="break-all rounded-lg border border-border bg-muted/40 p-3 text-xs">
          {deposit.accountIdHex}
        </code>
        <Button type="button" variant="outline" onClick={copy}>
          Copy address
        </Button>
      </CardContent>
    </Card>
  )
}
