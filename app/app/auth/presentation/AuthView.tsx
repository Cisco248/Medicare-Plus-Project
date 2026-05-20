import { AuthForm } from "./AuthForm";
import { PageShell } from "@/lib/components/PageShell";
import { config } from "@/lib/config";

export function AuthView() {
  return (
    <PageShell narrow className="flex min-h-[calc(100vh-8rem)] items-center py-12">
      <div className="w-full">
        <div className="mb-8 text-center">
          <p className="text-sm font-medium text-brand-400">Welcome to {config.appName}</p>
          <h1 className="mt-2 text-3xl font-bold text-white">
            {config.appName} account
          </h1>
          <p className="mt-2 text-sm text-zinc-500">
            Sign in or create an account to continue
          </p>
        </div>
        <AuthForm />
      </div>
    </PageShell>
  );
}
