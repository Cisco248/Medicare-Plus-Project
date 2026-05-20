import Link from "next/link";
import { config } from "@/lib/config";
import { Button } from "@/lib/components/Button";

const navLinks = [
  { href: "/landing#features", label: "Features" },
  { href: "/landing#how-it-works", label: "How it works" },
  { href: "/landing#about", label: "About" },
];

export function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b border-surface-500/40 bg-surface-900/80 backdrop-blur-md">
      <nav className="mx-auto flex h-16 max-w-6xl items-center justify-between px-6">
        <Link href="/landing" className="flex items-center gap-2.5">
          <span className="flex h-9 w-9 items-center justify-center rounded-lg bg-brand-500 text-lg font-bold text-surface-900">
            M+
          </span>
          <span className="text-lg font-semibold text-white">{config.appName}</span>
        </Link>

        <ul className="hidden items-center gap-8 md:flex">
          {navLinks.map((link) => (
            <li key={link.href}>
              <Link
                href={link.href}
                className="text-sm text-zinc-400 transition-colors hover:text-brand-400"
              >
                {link.label}
              </Link>
            </li>
          ))}
        </ul>

        <div className="flex items-center gap-3">
          <Link
            href="/auth"
            className="hidden text-sm text-zinc-400 transition-colors hover:text-white sm:inline"
          >
            Sign in
          </Link>
          <Link href="/auth">
            <Button size="sm">Get started</Button>
          </Link>
        </div>
      </nav>
    </header>
  );
}
