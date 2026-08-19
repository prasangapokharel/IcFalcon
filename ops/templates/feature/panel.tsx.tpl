"use client"

import { useAuth } from "@/components/auth/auth-provider"
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
    <div className="card">
      <h2>{{Name}}</h2>
      <input value={name} onChange={(event) => setName(event.target.value)} placeholder="Name" />
      <button onClick={onCreate}>Create</button>
      {message ? <p>{message}</p> : null}
      <ul>
        {items.map((item) => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
    </div>
  )
}
