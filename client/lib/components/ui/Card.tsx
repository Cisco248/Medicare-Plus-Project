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
        "rounded-2xl border border-surface-500/60 bg-surface-800/80 p-6 backdrop-blur-sm",
        hover
          ? "transition-all duration-300 hover:border-brand-500/40 hover:bg-surface-700/80 hover:shadow-lg hover:shadow-brand-500/5"
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
