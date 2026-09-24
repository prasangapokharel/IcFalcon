"use client"

import { AuthClient } from "@icp-sdk/auth/client"
import type { Identity } from "@icp-sdk/core/agent"
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
    const authClient = new AuthClient({ identityProvider: iiUrl })
    setClient(authClient)
    if (authClient.isAuthenticated()) {
      authClient
        .getIdentity()
        .then((id) => {
          setIdentity(id)
          setReady(true)
        })
        .catch(() => {
          setIdentity(undefined)
          setReady(true)
        })
    } else {
      setIdentity(undefined)
      setReady(true)
    }
  }, [])

  const login = useCallback(async () => {
    if (!client) return
    try {
      const id = await client.signIn()
      setIdentity(id)
    } catch {
      // login cancelled or failed
    }
  }, [client])

  const logout = useCallback(async () => {
    if (!client) return
    await client.signOut()
    setIdentity(undefined)
  }, [client])

  const value = useMemo<AuthState>(
    () => ({
      identity,
      principal: identity && !identity.getPrincipal().isAnonymous() ? identity.getPrincipal().toText() : "",
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
