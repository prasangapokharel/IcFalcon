import { SetupCommand } from "@/components/home/SetupCommand"
import Image from "next/image"

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

        <div className="flex w-full flex-col items-center gap-6">
          <div className="flex flex-col gap-3">
            <h1 className="text-3xl font-semibold tracking-tight sm:text-4xl">
              Welcome to IcFalcon
            </h1>
            <p className="text-base text-muted-foreground sm:text-lg">
              The Motoko framework for Internet Computer apps.
            </p>
          </div>

          <SetupCommand />
        </div>
      </div>
    </main>
  )
}
