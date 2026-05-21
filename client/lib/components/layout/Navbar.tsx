import Link from "next/link";
import { config } from "@/lib/config";
import { Button } from "@/lib/components/ui/Button";

const navLinks = [
  { href: "/landing#features", label: "Features" },
  { href: "/landing#how-it-works", label: "How it works" },
  { href: "/landing#about", label: "About" },
];

export function Navbar() {
  return (
    <header className="sticky top-0 z-50 bg-[#3A5DEB] backdrop-blur-md">
      <nav className="flex justify-between w-full px-20 py-3">
        <Link href="/landing" className="flex items-center gap-2.5">
          <span className="text-lg font-semibold text-white">
            {config.appName}
          </span>
        </Link>
        <div className="flex items-center gap-3">
          <Link href="/">
            <Button size="sm">How it works</Button>
          </Link>
        </div>
      </nav>
    </header>
  );
}
