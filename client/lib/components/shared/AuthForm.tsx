"use client";

import { useState, type SubmitEvent } from "react";
import Link from "next/link";
import { Input } from "@/lib/components/ui/Input";
import { Button } from "@/lib/components/ui/Button";
import { Card } from "@/lib/components/ui/Card";
import {
  hasAuthFormErrors,
  validateAuthForm,
  type AuthFormErrors,
} from "@/lib/utils/authValidation";

type AuthMode = "signin" | "signup";

export function AuthForm() {
  const [mode, setMode] = useState<AuthMode>("signin");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [errors, setErrors] = useState<AuthFormErrors>({});
  const [submitted, setSubmitted] = useState(false);

  function handleSubmit(e: SubmitEvent) {
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
                ? "bg-[#3A5DEB] text-surface-900"
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
              className="text-xs text-white transition-colors hover:text-[#3A5DEB]"
            >
              Forgot password?
            </button>
          </div>
        )}

        <Button type="submit" fullWidth size="lg">
          {mode === "signin" ? "Sign in" : "Create account"}
        </Button>

        {submitted && (
          <p className="rounded-lg border border-brand-500/30 bg-brand-500/10 px-4 py-3 text-center text-sm text-[#3A5DEB]">
            Form valid — connect to{" "}
            <code className="text-brand-200">authRepository</code> next.
          </p>
        )}
      </form>

      <p className="mt-6 text-center text-sm text-zinc-500">
        <Link
          href="/dashboard"
          className="text-white transition-colors hover:text-[#3A5DEB]"
        >
          ← Back to home
        </Link>
      </p>
    </Card>
  );
}
