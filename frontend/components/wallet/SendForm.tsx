"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Field, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { useSendTransfer } from "@/hooks/wallet/useSendTransfer"
import type { Identity } from "@dfinity/agent"

type Props = {
  identity: Identity | undefined
  onSent: () => void
}

export function SendForm({ identity, onSent }: Props) {
  const [to, setTo] = useState("")
  const [amount, setAmount] = useState("")
  const [confirming, setConfirming] = useState(false)
  const { sending, error, message, preview, execute, clear } = useSendTransfer(identity)

  async function onConfirm() {
    const ok = await execute(to, amount)
    if (ok) {
      setConfirming(false)
      setTo("")
      setAmount("")
      onSent()
    }
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Send ICP</CardTitle>
      </CardHeader>
      <CardContent className="flex flex-col gap-4">
        {!confirming ? (
          <FieldGroup>
            <Field>
              <FieldLabel htmlFor="send-to">Recipient principal</FieldLabel>
              <Input
                id="send-to"
                value={to}
                onChange={(e) => setTo(e.target.value)}
                placeholder="aaaaa-aa"
              />
            </Field>
            <Field>
              <FieldLabel htmlFor="send-amount">Amount (ICP)</FieldLabel>
              <Input
                id="send-amount"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                placeholder="0.1"
              />
            </Field>
            <Button
              type="button"
              disabled={!to || !amount}
              onClick={async () => {
                clear()
                const ok = await preview(to, amount)
                if (ok) setConfirming(true)
              }}
            >
              Review
            </Button>
          </FieldGroup>
        ) : (
          <div className="flex flex-col gap-3 text-sm">
            <p>
              Send <strong>{amount}</strong> ICP to
            </p>
            <code className="break-all rounded border border-border p-2 text-xs">{to}</code>
            <p className="text-muted-foreground">Ledger fee applies on top of amount.</p>
            <div className="flex gap-2">
              <Button type="button" variant="outline" onClick={() => setConfirming(false)}>
                Back
              </Button>
              <Button type="button" disabled={sending} onClick={onConfirm}>
                {sending ? "Sending…" : "Confirm send"}
              </Button>
            </div>
          </div>
        )}
        {error ? <p className="text-sm text-destructive">{error}</p> : null}
        {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
      </CardContent>
    </Card>
  )
}
