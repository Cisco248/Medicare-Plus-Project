"use client";

import { useState, type FormEvent } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Input } from "@/lib/components/ui/Input";
import { Button } from "@/lib/components/ui/Button";
import { Card } from "@/lib/components/ui/Card";
import {
  hasAuthFormErrors,
  validateAuthForm,
  validateSignUpFields,
  type AuthFormErrors,
} from "@/lib/utils/authValidation";
import { authRepository } from "@/app/auth/data/authRepository";
import { ApiError } from "@/lib/api/client";

type AuthMode = "signin" | "signup";

export function AuthForm() {
  const router = useRouter();
  const [mode, setMode] = useState<AuthMode>("signin");
  const [fname, setFname] = useState("");
  const [lname, setLname] = useState("");
  const [mobnum, setMobnum] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [errors, setErrors] = useState<AuthFormErrors>({});
  const [submitting, setSubmitting] = useState(false);
  const [serverError, setServerError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  function resetForms() {
    setErrors({});
    setServerError(null);
    setSuccess(null);
  }

  async function handleSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    resetForms();

    const baseErrors = validateAuthForm(email, password);
    const allErrors: AuthFormErrors =
      mode === "signup"
        ? {
            ...baseErrors,
            ...validateSignUpFields(
              { fname, lname, mobnum, confirmPassword },
              password,
            ),
          }
        : baseErrors;

    setErrors(allErrors);
    if (hasAuthFormErrors(allErrors)) return;

    setSubmitting(true);
    try {
      if (mode === "signup") {
        await authRepository.register({
          fname: fname.trim(),
          lname: lname.trim(),
          email: email.trim(),
          mobnum: mobnum.trim(),
          password,
          conpassword: confirmPassword,
        });
        await authRepository.login({ email: email.trim(), password });
        setSuccess("Account created — redirecting to your dashboard...");
      } else {
        await authRepository.login({ email: email.trim(), password });
        setSuccess("Signed in — redirecting...");
      }
      router.push("/dashboard");
    } catch (err) {
      const message =
        err instanceof ApiError
          ? err.message
          : err instanceof Error
            ? err.message
            : "Something went wrong. Please try again.";
      setServerError(message);
    } finally {
      setSubmitting(false);
    }
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
              resetForms();
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
        {mode === "signup" && (
          <div className="grid grid-cols-2 gap-4">
            <Input
              label="First name"
              type="text"
              placeholder="Jane"
              value={fname}
              onChange={(e) => setFname(e.target.value)}
              error={errors.fname}
              autoComplete="given-name"
            />
            <Input
              label="Last name"
              type="text"
              placeholder="Doe"
              value={lname}
              onChange={(e) => setLname(e.target.value)}
              error={errors.lname}
              autoComplete="family-name"
            />
          </div>
        )}

        <Input
          label="Email address"
          type="email"
          placeholder="you@example.com"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          error={errors.email}
          autoComplete="email"
        />

        {mode === "signup" && (
          <Input
            label="Mobile number"
            type="tel"
            placeholder="0771234567"
            value={mobnum}
            onChange={(e) => setMobnum(e.target.value)}
            error={errors.mobnum}
            autoComplete="tel"
          />
        )}

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
            error={errors.confirmPassword}
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

        <Button type="submit" fullWidth size="lg" disabled={submitting}>
          {submitting
            ? mode === "signin"
              ? "Signing in..."
              : "Creating account..."
            : mode === "signin"
              ? "Sign in"
              : "Create account"}
        </Button>

        {serverError && (
          <p className="rounded-lg border border-red-500/30 bg-red-500/10 px-4 py-3 text-center text-sm text-red-300">
            {serverError}
          </p>
        )}
        {success && (
          <p className="rounded-lg border border-brand-500/30 bg-brand-500/10 px-4 py-3 text-center text-sm text-[#3A5DEB]">
            {success}
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
