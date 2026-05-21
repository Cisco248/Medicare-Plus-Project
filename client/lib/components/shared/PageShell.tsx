import type { ReactNode } from "react";

type PageShellProps = {
  children: ReactNode;
  narrow?: boolean;
  className?: string;
};

export function PageShell({ children, narrow = false, className = "" }: PageShellProps) {
  return (
    <div
      className={[
        "mx-auto w-full flex-1 px-6 py-10",
        narrow ? "max-w-lg" : "max-w-6xl",
        className,
      ]
        .filter(Boolean)
        .join(" ")}
    >
      {children}
    </div>
  );
}
