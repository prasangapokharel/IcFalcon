"use client"

import { useAuth } from "@/components/auth/auth-provider"
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
    <div className="card">
      <h2>Starter Module</h2>
      <label>Username</label>
      <input value={username} onChange={(event) => setUsername(event.target.value)} />
      <button onClick={onRegister}>Register</button>
      <label style={{ marginTop: "1rem", display: "block" }}>Feature name</label>
      <input value={name} onChange={(event) => setName(event.target.value)} />
      <button onClick={onCreate}>Create feature</button>
      {message ? <p>{message}</p> : null}
      <ul>
        {items.map((item) => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
    </div>
  )
}
