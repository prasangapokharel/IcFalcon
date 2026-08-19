"use client"

import { useAuth } from "@/components/auth/auth-provider"
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
    <div className="card">
      <h2>Product</h2>
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
