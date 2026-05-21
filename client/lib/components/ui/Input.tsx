import type { InputHTMLAttributes } from "react";

type InputProps = InputHTMLAttributes<HTMLInputElement> & {
  label: string;
  error?: string;
  hint?: string;
};

export function Input({ label, error, hint, id, className = "", ...props }: InputProps) {
  const inputId = id ?? label.toLowerCase().replace(/\s+/g, "-");

  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={inputId} className="text-sm font-medium text-zinc-300">
        {label}
      </label>
      <input
        id={inputId}
        className={[
          "w-full rounded-lg border bg-surface-800 px-4 py-2.5 text-white placeholder:text-zinc-500",
          "transition-colors duration-200",
          "focus:border-brand-500 focus:outline-none focus:ring-2 focus:ring-brand-500/30",
          error ? "border-red-500/70" : "border-surface-500",
          className,
        ]
          .filter(Boolean)
          .join(" ")}
        {...props}
      />
      {error ? (
        <p className="text-xs text-red-400">{error}</p>
      ) : hint ? (
        <p className="text-xs text-zinc-500">{hint}</p>
      ) : null}
    </div>
  );
}
