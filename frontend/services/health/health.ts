import { call } from "@/services/client"

export function pingBackend() {
  return call(undefined, "Backend unreachable", (actor) => actor.ping())
}
