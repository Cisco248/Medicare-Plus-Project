import type { ReactNode } from "react";

type PageShellProps = {
  children: ReactNode;
  narrow?: boolean;
  className?: string;
};

export function PageShell({
  children,
  narrow = false,
  className = "",
}: PageShellProps) {
  return (
    <div
      className={[
        "m-0 p-0 w-full h-dvh",
        narrow ? "sm:w-sm" : "xl:w-full",
        className,
      ]
        .filter(Boolean)
        .join(" ")}
    >
      {children}
    </div>
  );
}
