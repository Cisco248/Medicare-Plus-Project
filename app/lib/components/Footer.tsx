import Link from "next/link";
import { config } from "@/lib/config";

export function Footer() {
  return (
    <footer className="mt-auto border-t border-surface-500/40 bg-surface-800/50">
      <div className="mx-auto flex max-w-6xl flex-col gap-6 px-6 py-10 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p className="font-semibold text-white">{config.appName}</p>
          <p className="mt-1 text-sm text-zinc-500">
            Smart healthcare management for everyone.
          </p>
        </div>
        <div className="flex flex-wrap gap-6 text-sm text-zinc-500">
          <Link href="/landing" className="transition-colors hover:text-brand-400">
            Home
          </Link>
          <Link href="/auth" className="transition-colors hover:text-brand-400">
            Sign in
          </Link>
          <span>© {new Date().getFullYear()} Medicare+</span>
        </div>
      </div>
    </footer>
  );
}
