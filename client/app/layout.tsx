import type { Metadata } from "next";
import { Navbar } from "@/lib/components/layout/Navbar";
import { Footer } from "@/lib/components/layout/Footer";
import "@/lib/styles/global.css";

export const metadata: Metadata = {
  title: "Medicare+ Solution",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full antialiased">
      <body className="flex h-full flex-col bg-surface-900 text-zinc-100">
        <div className="flex flex-1 flex-col">{children}</div>
      </body>
    </html>
  );
}
