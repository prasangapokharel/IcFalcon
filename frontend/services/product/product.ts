import type { Identity } from "@dfinity/agent"
import { call } from "@/services/client"

export type Product = { id: string; name: string }

export function createProduct(identity: Identity | undefined, name: string) {
  return call(identity, "Create failed", (actor) => (actor as any).createProduct(name))
}

export function listProducts(offset = 0, limit = 20) {
  return call(undefined, "Load failed", (actor) => (actor as any).listProducts(BigInt(offset), BigInt(limit)))
}
