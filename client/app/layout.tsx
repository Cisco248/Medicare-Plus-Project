import type { Metadata } from "next";
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
      <body className="flex h-dvh flex-col bg-surface-900 text-zinc-100">
        <div className="flex flex-col">{children}</div>
      </body>
    </html>
  );
}
