"use client"

import { AuthClient } from "@dfinity/auth-client"
import type { Identity } from "@dfinity/agent"
import { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react"
import { iiUrl } from "@/services/icp"

type AuthState = {
  identity: Identity | undefined
  principal: string
  ready: boolean
  login: () => Promise<void>
  logout: () => Promise<void>
}

const AuthContext = createContext<AuthState | null>(null)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [client, setClient] = useState<AuthClient | null>(null)
  const [identity, setIdentity] = useState<Identity | undefined>(undefined)
  const [ready, setReady] = useState(false)

  useEffect(() => {
    AuthClient.create().then((authClient) => {
      setClient(authClient)
      setIdentity(authClient.getIdentity())
      setReady(true)
    })
  }, [])

  const login = useCallback(async () => {
    if (!client) return
    await client.login({
      identityProvider: iiUrl,
      onSuccess: () => setIdentity(client.getIdentity()),
    })
  }, [client])

  const logout = useCallback(async () => {
    if (!client) return
    await client.logout()
    setIdentity(undefined)
  }, [client])

  const value = useMemo<AuthState>(
    () => ({
      identity,
      principal: identity?.getPrincipal().toText() ?? "",
      ready,
      login,
      logout,
    }),
    [identity, ready, login, logout],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) throw new Error("useAuth must be used inside AuthProvider")
  return context
}
