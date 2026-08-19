import type { Identity } from "@dfinity/agent"
import { call } from "@/services/client"

export type Shop = { id: string; name: string }

export function createShop(identity: Identity | undefined, name: string) {
  return call(identity, "Create failed", (actor) => (actor as any).createShop(name))
}

export function listShops(offset = 0, limit = 20) {
  return call(undefined, "Load failed", (actor) => (actor as any).listShops(BigInt(offset), BigInt(limit)))
}
