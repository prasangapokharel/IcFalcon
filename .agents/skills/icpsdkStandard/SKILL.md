---
name: icpsdkStandard
description: >-
  Complete guide and reference for @icp-sdk ecosystem (@icp-sdk/core, @icp-sdk/auth,
  @icp-sdk/signer) in IcFalcon frontend — agent, actors, candid, principal, auth, and signers.
---

# ICP SDK Standard

Official guide for the modern `@icp-sdk` package ecosystem across the IcFalcon frontend.

Replaces legacy `@dfinity/*` packages (`@dfinity/agent`, `@dfinity/auth-client`, `@dfinity/candid`, `@dfinity/identity`, `@dfinity/principal`).

---

## Package Ecosystem

| Package | Purpose | Primary Submodules |
|---|---|---|
| `@icp-sdk/core` | Core protocol interactions (agent, candid, identity, principal) | `/agent`, `/candid`, `/identity`, `/principal` |
| `@icp-sdk/auth` | Internet Identity and OpenID browser authentication | `/client` (`AuthClient`) |
| `@icp-sdk/signer` | ICRC-25 compliant wallet & signer integrations | `/agent` (`SignerAgent`), `/web`, `/extension` |

> **Important**: Never import from the root of `@icp-sdk/core` or `@icp-sdk/auth`. Always use submodules (e.g. `@icp-sdk/core/agent`, `@icp-sdk/auth/client`).

---

## Submodule Map

### 1. `@icp-sdk/core/agent`
- **`Actor`**: `Actor.createActor<T>(idlFactory, { agent, canisterId })`
- **`HttpAgent`**: `HttpAgent.create({ host, identity })`
- **`Identity`**: Type definition for authenticated and anonymous identities

### 2. `@icp-sdk/core/candid`
- **`IDL`**: Candid type constructors (`IDL.Service`, `IDL.Func`, `IDL.Record`, `IDL.Variant`, `IDL.Text`, `IDL.Nat`, etc.)

### 3. `@icp-sdk/core/principal`
- **`Principal`**: `Principal.fromText(str)`, `Principal.anonymous()`, `toText()`

### 4. `@icp-sdk/core/identity`
- **Keys & Delegations**: `Ed25519KeyIdentity`, `ECDSAKeyIdentity`, `DelegationIdentity`, `AttributesIdentity`

### 5. `@icp-sdk/auth/client`
- **`AuthClient`**: `new AuthClient({ identityProvider })`, `signIn()`, `signOut()`, `getIdentity()`, `isAuthenticated()`, `requestAttributes({ keys, nonce })`
- **`scopedKeys`**: Helper for one-click OpenID attributes (e.g. Google, Apple, Microsoft)

### 6. `@icp-sdk/signer`
- **`Signer`**: Standardized interface for ICRC-25 wallets (OISY, Plug, NFID)
- **`SignerAgent`**: Drop-in `HttpAgent` replacement routing canister calls through user signers
- **Transports**: `PostMessageTransport` (window), `UrlTransport` (redirects), `BrowserExtensionTransport` (injected extensions)

---

## Implementation in IcFalcon

### 1. Actor Factory (`services/client.ts`)

```typescript
import { Actor, HttpAgent } from "@icp-sdk/core/agent"
import type { Identity } from "@icp-sdk/core/agent"
import { idlFactory } from "@/services/idl"
import { canisterId, host } from "@/services/icp"

export type Outcome<T> = { ok: true; data: T } | { ok: false; error: string }

export async function createActor(identity?: Identity): Promise<AppActor> {
  const agent = await HttpAgent.create({ host, identity })
  if (host.includes("127.0.0.1") || host.includes("localhost")) {
    await agent.fetchRootKey()
  }
  return Actor.createActor<AppActor>(idlFactory, { agent, canisterId })
}

export async function call<T>(
  identity: Identity | undefined,
  errorLabel: string,
  run: (actor: AppActor) => Promise<T>,
): Promise<Outcome<T>> {
  try {
    const actor = await createActor(identity)
    const data = await run(actor)
    return { ok: true, data }
  } catch (error) {
    const message = error instanceof Error ? error.message : errorLabel
    return { ok: false, error: message }
  }
}
```

### 2. Candid IDL Definition (`services/idl.ts`)

```typescript
import { IDL } from "@icp-sdk/core/candid"

export const idlFactory = ({ IDL: idl }: { IDL: typeof IDL }) => {
  const ApiError = idl.Record({ code: idl.Nat32, message: idl.Text })
  const ApiResult = (T: any) => idl.Variant({ ok: T, err: ApiError })
  
  return idl.Service({
    ping: idl.Func([], [idl.Text], ["query"]),
  })
}
```

### 3. Internet Identity Authentication (`components/auth/auth-provider.tsx`)

```typescript
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
      authClient.getIdentity().then((id) => {
        setIdentity(id)
        setReady(true)
      }).catch(() => {
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
    } catch {}
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
```

### 4. Asset Signer Integration (`@icp-sdk/signer`)

For interactive multi-wallet approval (e.g. OISY, NFID):

```typescript
import { Signer } from "@icp-sdk/signer"
import { PostMessageTransport } from "@icp-sdk/signer/web"
import { SignerAgent } from "@icp-sdk/signer/agent"

const transport = new PostMessageTransport({ url: "https://oisy.com/sign" })
const signer = new Signer({ transport })
const accounts = await signer.getAccounts()

const agent = await SignerAgent.create({
  signer,
  account: accounts[0].owner,
})
```

---

## Architectural Rules

1. **Submodule Imports Only**: Always import from `@icp-sdk/core/*` or `@icp-sdk/auth/*`.
2. **Actor Encapsulation**: Never create `HttpAgent` in UI components — isolate inside `services/client.ts`.
3. **Pure Lib Layer**: Files in `lib/` must never import `@icp-sdk/*` or React.
4. **Synchronous Actor Calls**: Use the `call()` wrapper in `services/client.ts` returning `Outcome<T>`.
5. **No Deprecated Packages**: Strictly avoid `@dfinity/*` imports.

---

## Related

| Topic | Path |
|---|---|
| Frontend standard | [`frontendStandard/SKILL.md`](../frontendStandard/SKILL.md) |
| API endpoints | [`endpointsStandard/SKILL.md`](../endpointsStandard/SKILL.md) |
| Internet Identity auth | [`motokoStandard/internetIdentityAuthStandard/SKILL.md`](../motokoStandard/internetIdentityAuthStandard/SKILL.md) |
| Layering rules | [`layeringStandard/SKILL.md`](../layeringStandard/SKILL.md) |
