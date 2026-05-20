import type { Metadata } from "next";
import { Navbar } from "@/lib/components/Navbar";
import { Footer } from "@/lib/components/Footer";
import "./global.css";

export const metadata: Metadata = {
  title: "Medicare+ Solution",
  description: "Smart healthcare management platform",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full antialiased">
      <body className="flex min-h-full flex-col bg-surface-900 text-zinc-100">
        <Navbar />
        <div className="flex flex-1 flex-col">{children}</div>
        <Footer />
      </body>
    </html>
  );
}
