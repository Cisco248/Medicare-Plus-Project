import type { ReactNode } from "react";

type CardProps = {
  children: ReactNode;
  className?: string;
  hover?: boolean;
};

export function Card({ children, className = "", hover = false }: CardProps) {
  return (
    <div
      className={[
        "rounded-2xl border border-surface-500/60 bg-brand-800/50 p-6 backdrop-blur-sm w-200",
        hover
          ? "transition-all duration-300 hover:border-brand-500/40 hover:bg-brand-700/60 hover:shadow-lg hover:shadow-brand-500/5"
          : "",
        className,
      ]
        .filter(Boolean)
        .join(" ")}
    >
      {children}
    </div>
  );
}
