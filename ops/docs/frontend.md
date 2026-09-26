# Frontend Architecture (Next.js + @icp-sdk)

IcFalcon uses **Next.js 15** with **shadcn/ui** and the modern **`@icp-sdk`** ecosystem for high-performance Internet Computer frontends.

---

## 1. Directory Layout

```
frontend/
├── src/
│   ├── app/                 # Next.js App Router (pages & layouts)
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── wallet/
│   ├── components/          # Reusable UI components
│   │   ├── ui/              # shadcn/ui primitives
│   │   ├── auth/            # Internet Identity modal & login buttons
│   │   └── features/        # Feature panels (OrderPanel, WalletPanel, etc.)
│   ├── hooks/               # Custom React hooks (useAuth, useWallet)
│   ├── services/            # Frontend actor callers & API integration
│   └── lib/                 # Utility functions & Candid declarations
├── next.config.ts           # Static export configuration (`output: "export"`)
└── package.json             # Pure @icp-sdk dependencies
```

---

## 2. Using `@icp-sdk`

IcFalcon replaces legacy `@dfinity/*` packages with modern `@icp-sdk`:

```bash
npm install @icp-sdk/core @icp-sdk/auth @icp-sdk/signer
```

### Internet Identity Authentication

```typescript
// frontend/src/hooks/useAuth.ts
import { AuthClient } from "@icp-sdk/auth";

export async function loginWithInternetIdentity() {
  const authClient = await AuthClient.create();
  
  await new Promise<void>((resolve, reject) => {
    authClient.login({
      identityProvider: process.env.NEXT_PUBLIC_II_URL || "https://identity.ic0.app",
      onSuccess: () => resolve(),
      onError: (err) => reject(err),
    });
  });

  return authClient.getIdentity();
}
```

### Initializing Canister Actors

```typescript
// frontend/src/services/actor.ts
import { Actor, HttpAgent } from "@icp-sdk/core";
import { idlFactory } from "../lib/declarations/app.did.js";

export function createCanisterActor(identity?: any) {
  const host = process.env.NEXT_PUBLIC_IC_HOST || "https://icp-api.io";
  const agent = new HttpAgent({ host, identity });

  return Actor.createActor(idlFactory, {
    agent,
    canisterId: process.env.NEXT_PUBLIC_CANISTER_ID!,
  });
}
```

---

## 3. Local Development & Static Export

```bash
# Run local dev server with hot reloading
falcon f:dev

# Build static bundle for production
falcon f:build
```

Static export produces pure HTML/CSS/JS inside `frontend/out/`, ready for direct deployment to the IC asset canister via `dfx deploy` or `falcon p:ship`.
