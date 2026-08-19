import type { Identity } from "@dfinity/agent"
import { call } from "@/services/client"

export type {{Name}} = { id: string; name: string }

export function create{{Name}}(identity: Identity | undefined, name: string) {
  return call(identity, "Create failed", (actor) => (actor as any).create{{Name}}(name))
}

export function list{{Name}}s(offset = 0, limit = 20) {
  return call(undefined, "Load failed", (actor) => (actor as any).list{{Name}}s(BigInt(offset), BigInt(limit)))
}
