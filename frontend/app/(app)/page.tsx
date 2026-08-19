"use client"

import { useAuth } from "@/components/auth/auth-provider"
import { FeaturePanel } from "@/components/feature/feature-panel"
import { useEffect, useState } from "react"
import { loadHealth } from "@/services/feature/feature"

export default function DashboardPage() {
  const { identity, principal, ready, login, logout } = useAuth()
  const [health, setHealth] = useState("loading...")

  useEffect(() => {
    loadHealth().then((result) => {
      if (result.ok) {
        setHealth(`${result.data.status} v${result.data.version} · users ${result.data.userCount} · features ${result.data.featureCount}`)
      } else {
        setHealth(result.error)
      }
    })
  }, [])

  if (!ready) return <main>Loading...</main>

  return (
    <main>
      <h1>IcFalcon</h1>
      <p>Clone, customize, deploy your own ICP canister.</p>
      <div className="card">
        <p>{health}</p>
        {identity ? (
          <>
            <p>Principal: {principal}</p>
            <button onClick={logout}>Logout</button>
            <FeaturePanel />
          </>
        ) : (
          <button onClick={login}>Login with Internet Identity</button>
        )}
      </div>
    </main>
  )
}
