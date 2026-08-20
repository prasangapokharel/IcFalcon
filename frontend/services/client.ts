import { Actor, HttpAgent } from "@dfinity/agent"
import type { Identity } from "@dfinity/agent"
import { idlFactory } from "@/services/idl"
import { canisterId, host } from "@/services/icp"

export type Outcome<T> = { ok: true; data: T } | { ok: false; error: string }

export type WalletDeposit = {
  icrcOwner: { toText: () => string }
  icrcSubaccount: [] | [Uint8Array]
  accountIdHex: string
  qrPayload: string
}

export type WalletBalance = {
  amount: bigint
  symbol: string
  decimals: number
}

export type TxView = {
  id: string
  kind: string
  amount: bigint
  fee: bigint
  status: string
  blockIndex: [] | [bigint]
  createdAt: bigint
}

export type AppActor = {
  ping: () => Promise<string>
  status: () => Promise<{
    status: string
    version: string
    featureCount: bigint
    userCount: bigint
  }>
  register: (username: string) => Promise<{ ok?: unknown; err?: { message: string } }>
  me: () => Promise<{ ok?: { username: string; role: string }; err?: { message: string } }>
  createFeature: (name: string) => Promise<{ ok?: { id: string; name: string }; err?: { message: string } }>
  listFeatures: (offset: bigint, limit: bigint) => Promise<{
    ok?: { items: Array<{ id: string; name: string }>; total: bigint }
    err?: { message: string }
  }>
  registerWallet: () => Promise<{ ok?: WalletDeposit; err?: { message: string } }>
  depositInfo: () => Promise<{ ok?: WalletDeposit; err?: { message: string } }>
  getBalance: () => Promise<{ ok?: WalletBalance; err?: { message: string } }>
  proposeTransfer: (
    transferId: string,
    toPrincipal: string,
    amount: bigint,
  ) => Promise<{
    ok?: { transferId: string; fee: bigint; totalDebit: bigint; balance: bigint }
    err?: { code: number; message: string }
  }>
  executeTransfer: (
    transferId: string,
    toPrincipal: string,
    amount: bigint,
  ) => Promise<{ ok?: { transferId: string; blockIndex: bigint }; err?: { message: string } }>
  sendTransfer: (
    transferId: string,
    toPrincipal: string,
    amount: bigint,
  ) => Promise<{ ok?: { transferId: string; blockIndex: bigint }; err?: { message: string } }>
  listTransactions: (
    offset: bigint,
    limit: bigint,
  ) => Promise<{ ok?: { items: TxView[]; total: bigint }; err?: { message: string } }>
  adminTreasury: () => Promise<{ ok?: { registeredWallets: bigint; symbol: string }; err?: { message: string } }>
}

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
