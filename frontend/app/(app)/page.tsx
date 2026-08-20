import { BackendStatus } from "@/components/home/BackendStatus"
import Image from "next/image"
import Link from "next/link"

export default function HomePage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center px-6 py-12">
      <div className="flex w-full max-w-lg flex-col items-center gap-10 text-center">
        <Image
          src="/brand/logo.png"
          alt="IcFalcon"
          width={320}
          height={380}
          priority
          className="h-auto w-full max-w-xs drop-shadow-2xl sm:max-w-sm"
        />

        <div className="flex flex-col items-center gap-4">
          <div className="flex flex-col gap-3">
            <h1 className="text-3xl font-semibold tracking-tight sm:text-4xl">
              Welcome to IcFalcon
            </h1>
            <p className="text-base text-muted-foreground sm:text-lg">
              The Motoko framework for Internet Computer apps.
            </p>
          </div>
          <BackendStatus />
          <Link
            href="/wallet"
            className="text-sm font-medium text-primary underline-offset-4 hover:underline"
          >
            Open wallet demo
          </Link>
        </div>
      </div>
    </main>
  )
}
