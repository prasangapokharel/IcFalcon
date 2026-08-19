"use client"

import { useAuth } from "@/components/auth/auth-provider"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Field, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { create{{Name}}, list{{Name}}s } from "@/services/{{kebab}}/{{kebab}}"
import { useEffect, useState } from "react"

export function {{Name}}Panel() {
  const { identity } = useAuth()
  const [name, setName] = useState("")
  const [items, setItems] = useState<Array<{ id: string; name: string }>>([])
  const [message, setMessage] = useState("")

  async function refresh() {
    const result = await list{{Name}}s()
    if (!result.ok) return
    const data = result.data as { ok?: { items: Array<{ id: string; name: string }> } }
    if (data.ok) setItems(data.ok.items)
  }

  useEffect(() => {
    refresh()
  }, [])

  async function onCreate() {
    const result = await create{{Name}}(identity, name)
    setMessage(result.ok ? "{{Name}} created" : result.error)
    setName("")
    await refresh()
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>{{Name}}</CardTitle>
      </CardHeader>
      <CardContent className="flex flex-col gap-4">
        <FieldGroup>
          <Field>
            <FieldLabel htmlFor="{{kebab}}-name">Name</FieldLabel>
            <Input
              id="{{kebab}}-name"
              value={name}
              onChange={(event) => setName(event.target.value)}
              placeholder="Name"
            />
          </Field>
          <Button type="button" onClick={onCreate}>
            Create
          </Button>
        </FieldGroup>
        {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        <ul className="flex flex-col gap-2 text-sm">
          {items.map((item) => (
            <li key={item.id} className="rounded-lg border border-border px-3 py-2">
              {item.name}
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  )
}
