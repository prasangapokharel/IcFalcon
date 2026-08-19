"use client"

import { useAuth } from "@/components/auth/auth-provider"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Field, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { createProduct, listProducts } from "@/services/product/product"
import { useEffect, useState } from "react"

export function ProductPanel() {
  const { identity } = useAuth()
  const [name, setName] = useState("")
  const [items, setItems] = useState<Array<{ id: string; name: string }>>([])
  const [message, setMessage] = useState("")

  async function refresh() {
    const result = await listProducts()
    if (!result.ok) return
    const data = result.data as { ok?: { items: Array<{ id: string; name: string }> } }
    if (data.ok) setItems(data.ok.items)
  }

  useEffect(() => {
    refresh()
  }, [])

  async function onCreate() {
    const result = await createProduct(identity, name)
    setMessage(result.ok ? "Product created" : result.error)
    setName("")
    await refresh()
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Product</CardTitle>
      </CardHeader>
      <CardContent className="flex flex-col gap-4">
        <FieldGroup>
          <Field>
            <FieldLabel htmlFor="product-name">Name</FieldLabel>
            <Input
              id="product-name"
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
