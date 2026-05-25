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
    <html lang="en" className="box-border m-0 p-0 antialiased">
      <body className="flex flex-col bg-surface-900">
        <div>{children}</div>
      </body>
    </html>
  );
}
