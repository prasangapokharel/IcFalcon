import { WalletPanel } from "@/components/wallet/WalletPanel"
import Link from "next/link"

export default function WalletPage() {
  return (
    <main className="min-h-screen px-6 py-12">
      <div className="mb-8 flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Wallet demo</h1>
        <Link href="/" className="text-sm text-muted-foreground hover:text-foreground">
          Home
        </Link>
      </div>
      <WalletPanel />
    </main>
  )
}
