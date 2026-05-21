import Link from "next/link";
import { config } from "@/lib/config";

export function Footer() {
  return (
    <footer className=" flex justify-between px-20 py-3 w-full h-fit bg-[#3A5DEB]">
        <div className="flex flex-col">
          <p className="font-semibold text-white text-lg">{config.appName}</p>
          <p className="text-xs text-white">
            OpenSource Government e-Hospital
          </p>
        </div>
        <div className="flex flex-wrap items-center justify-center gap-6 text-sm text-white">
          <span>Medicare+ Project © {new Date().getFullYear()}. Design by Team Medicare13</span>
        </div>
    </footer>
  );
}
