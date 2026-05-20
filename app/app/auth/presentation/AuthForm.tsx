"use client";

import { useState, type FormEvent } from "react";
import Link from "next/link";
import { Input } from "@/lib/components/Input";
import { Button } from "@/lib/components/Button";
import { Card } from "@/lib/components/Card";
import {
  hasAuthFormErrors,
  validateAuthForm,
  type AuthFormErrors,
} from "../utils/authValidation";

type AuthMode = "signin" | "signup";

export function AuthForm() {
  const [mode, setMode] = useState<AuthMode>("signin");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [errors, setErrors] = useState<AuthFormErrors>({});
  const [submitted, setSubmitted] = useState(false);

  function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSubmitted(false);

    const validationErrors = validateAuthForm(email, password);
    if (mode === "signup" && password !== confirmPassword) {
      validationErrors.password = "Passwords do not match.";
    }

    setErrors(validationErrors);
    if (hasAuthFormErrors(validationErrors)) return;

    setSubmitted(true);
    // TODO: call authRepository.login() / authRepository.register()
  }

  return (
    <Card className="w-full">
      <div className="mb-8 flex rounded-lg bg-surface-900 p-1">
        {(["signin", "signup"] as const).map((tab) => (
          <button
            key={tab}
            type="button"
            onClick={() => {
              setMode(tab);
              setErrors({});
              setSubmitted(false);
            }}
            className={[
              "flex-1 rounded-md py-2 text-sm font-medium transition-colors",
              mode === tab
                ? "bg-brand-500 text-surface-900"
                : "text-zinc-400 hover:text-white",
            ].join(" ")}
          >
            {tab === "signin" ? "Sign in" : "Sign up"}
          </button>
        ))}
      </div>

      <form onSubmit={handleSubmit} className="flex flex-col gap-5" noValidate>
        <Input
          label="Email address"
          type="email"
          placeholder="you@example.com"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          error={errors.email}
          autoComplete="email"
        />
        <Input
          label="Password"
          type="password"
          placeholder="••••••••"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          error={errors.password}
          autoComplete={mode === "signin" ? "current-password" : "new-password"}
        />
        {mode === "signup" && (
          <Input
            label="Confirm password"
            type="password"
            placeholder="••••••••"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            autoComplete="new-password"
          />
        )}

        {mode === "signin" && (
          <div className="flex justify-end">
            <button
              type="button"
              className="text-xs text-brand-400 transition-colors hover:text-brand-300"
            >
              Forgot password?
            </button>
          </div>
        )}

        <Button type="submit" fullWidth size="lg">
          {mode === "signin" ? "Sign in" : "Create account"}
        </Button>

        {submitted && (
          <p className="rounded-lg border border-brand-500/30 bg-brand-500/10 px-4 py-3 text-center text-sm text-brand-300">
            Form valid — connect to <code className="text-brand-200">authRepository</code> next.
          </p>
        )}
      </form>

      <p className="mt-6 text-center text-sm text-zinc-500">
        <Link href="/landing" className="text-brand-400 hover:text-brand-300">
          ← Back to home
        </Link>
      </p>
    </Card>
  );
}
