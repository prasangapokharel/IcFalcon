"use client"

import {
  InputGroup,
  InputGroupAddon,
  InputGroupButton,
  InputGroupInput,
} from "@/components/ui/input-group"
import { CheckIcon, ClipboardIcon, InfoIcon } from "lucide-react"
import { useState } from "react"

const command = "falcon s:init"

export function SetupCommand() {
  const [copied, setCopied] = useState(false)

  async function onCopy() {
    await navigator.clipboard.writeText(command)
    setCopied(true)
    window.setTimeout(() => setCopied(false), 2000)
  }

  return (
    <div className="flex w-full max-w-md flex-col gap-2 text-left">
      <InputGroup className="h-11 font-mono text-sm">
        <InputGroupInput readOnly value={command} aria-label="Setup command" />
        <InputGroupAddon align="inline-end">
          <InputGroupButton
            type="button"
            size="icon-sm"
            onClick={onCopy}
            aria-label={copied ? "Copied" : "Copy command"}
          >
            {copied ? <CheckIcon /> : <ClipboardIcon />}
          </InputGroupButton>
        </InputGroupAddon>
      </InputGroup>
      <p className="flex items-center gap-2 text-sm text-muted-foreground">
        <InfoIcon className="size-4 shrink-0" />
        <span>This sets up your entire system — ready for local deploy, no dev server.</span>
      </p>
    </div>
  )
}
