"use client"

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { formatTokenAmount, type TxView } from "@/services/wallet/wallet"

type Props = {
  items: TxView[]
  loading: boolean
}

export function TxHistory({ items, loading }: Props) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>History</CardTitle>
      </CardHeader>
      <CardContent>
        {loading ? <p className="text-sm text-muted-foreground">Loading…</p> : null}
        {!loading && items.length === 0 ? (
          <p className="text-sm text-muted-foreground">No transactions yet.</p>
        ) : null}
        <ul className="flex flex-col gap-2">
          {items.map((tx) => (
            <li key={tx.id} className="rounded-lg border border-border px-3 py-2 text-sm">
              <div className="flex justify-between gap-2">
                <span className="font-medium">{tx.kind}</span>
                <span>{formatTokenAmount(tx.amount, 8)} ICP</span>
              </div>
              <div className="text-xs text-muted-foreground">
                {tx.status}
                {tx.blockIndex[0] !== undefined ? ` · block ${tx.blockIndex[0].toString()}` : ""}
              </div>
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  )
}
