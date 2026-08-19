"use client"

import { Badge } from "@/components/ui/badge"
import { Card, CardContent } from "@/components/ui/card"
import { useBackendHealth } from "@/hooks/health/useBackendHealth"
import { canisterId, host } from "@/services/icp"
import { CircleIcon } from "lucide-react"

function HealthBadge() {
  const { data, error, isLoading } = useBackendHealth()

  if (isLoading) {
    return (
      <Badge variant="secondary">
        <CircleIcon className="animate-pulse" />
        Checking backend
      </Badge>
    )
  }

  if (error || !data) {
    return (
      <Badge variant="destructive">
        <CircleIcon className="fill-current" />
        Backend offline
      </Badge>
    )
  }

  return (
    <Badge variant="outline">
      <CircleIcon className="fill-green-500 text-green-500" />
      Backend online
    </Badge>
  )
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex flex-col gap-1">
      <span className="text-xs text-muted-foreground">{label}</span>
      <span className="break-all font-mono text-sm">{value}</span>
    </div>
  )
}

export function BackendStatus() {
  return (
    <Card className="w-full max-w-md text-left">
      <CardContent className="flex flex-col gap-4">
        <HealthBadge />
        <InfoRow label="Your backend URL" value={host} />
        <InfoRow label="Your canister ID" value={canisterId} />
      </CardContent>
    </Card>
  )
}
