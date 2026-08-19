import type { Identity } from "@dfinity/agent"
import { call } from "@/services/client"

export type Feature = { id: string; name: string }

export function createFeature(identity: Identity | undefined, name: string) {
  return call(identity, "Create failed", (actor) => actor.createFeature(name))
}

export function listFeatures(offset = 0, limit = 20) {
  return call(undefined, "Load failed", (actor) => actor.listFeatures(BigInt(offset), BigInt(limit)))
}

export function registerUser(identity: Identity | undefined, username: string) {
  return call(identity, "Register failed", (actor) => actor.register(username))
}

export function loadProfile(identity: Identity | undefined) {
  return call(identity, "Profile failed", (actor) => actor.me())
}

export function loadHealth() {
  return call(undefined, "Health failed", (actor) => actor.status())
}
