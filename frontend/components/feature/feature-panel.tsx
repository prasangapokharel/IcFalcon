"use client"

import { useAuth } from "@/components/auth/auth-provider"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Field, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { createFeature, listFeatures, registerUser } from "@/services/feature/feature"
import { useEffect, useState } from "react"

export function FeaturePanel() {
  const { identity } = useAuth()
  const [username, setUsername] = useState("")
  const [name, setName] = useState("")
  const [items, setItems] = useState<Array<{ id: string; name: string }>>([])
  const [message, setMessage] = useState("")

  async function refresh() {
    const result = await listFeatures()
    if (result.ok && result.data.ok) {
      setItems(result.data.ok.items)
    }
  }

  useEffect(() => {
    refresh()
  }, [])

  async function onRegister() {
    const result = await registerUser(identity, username)
    setMessage(result.ok ? "Registered" : result.error)
    await refresh()
  }

  async function onCreate() {
    const result = await createFeature(identity, name)
    setMessage(result.ok ? "Feature created" : result.error)
    setName("")
    await refresh()
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Starter Module</CardTitle>
      </CardHeader>
      <CardContent className="flex flex-col gap-4">
        <FieldGroup>
          <Field>
            <FieldLabel htmlFor="username">Username</FieldLabel>
            <Input
              id="username"
              value={username}
              onChange={(event) => setUsername(event.target.value)}
            />
          </Field>
          <Button type="button" onClick={onRegister}>
            Register
          </Button>
        </FieldGroup>

        <FieldGroup>
          <Field>
            <FieldLabel htmlFor="feature-name">Feature name</FieldLabel>
            <Input
              id="feature-name"
              value={name}
              onChange={(event) => setName(event.target.value)}
            />
          </Field>
          <Button type="button" onClick={onCreate}>
            Create feature
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
