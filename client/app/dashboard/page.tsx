import Link from "next/link";
import { getLandingContent } from "@/lib/data/landingRepository";
import { Card } from "@/lib/components/ui/Card";
import { Button } from "@/lib/components/ui/Button";
import { PageShell } from "@/lib/components/shared/PageShell";

export default function LandingView() {
  const { hero, features, steps, stats } = getLandingContent();

  return (
    <>
      <section className="flex flex-col relative overflow-hidden border-b border-surface-500/30">
        <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_at_top,var(--color-brand-900)_0%,transparent_55%)] opacity-60" />
        <PageShell className="relative py-16 md:py-24">
          <span className="inline-flex items-center rounded-full border border-brand-500/30 bg-brand-500/10 px-3 py-1 text-xs font-medium text-brand-300">
            {hero.badge}
          </span>
          <h1 className="mt-6 max-w-3xl text-4xl font-bold tracking-tight text-white md:text-6xl">
            {hero.title}{" "}
            <span className="bg-linear-to-r from-brand-300 to-brand-500 bg-clip-text text-transparent">
              {hero.highlight}
            </span>
          </h1>
          <p className="mt-6 max-w-2xl text-lg leading-relaxed text-zinc-400">
            {hero.description}
          </p>
          <div className="mt-10 flex flex-wrap gap-4">
            <Link href="/auth">
              <Button size="lg">Get started free</Button>
            </Link>
            <Link href="#features">
              <Button variant="outline" size="lg">
                Explore features
              </Button>
            </Link>
          </div>

          <div className="mt-16 grid grid-cols-3 gap-6 border-t border-surface-500/40 pt-10 sm:max-w-lg">
            {stats.map((stat) => (
              <div key={stat.label}>
                <p className="text-2xl font-bold text-brand-400">
                  {stat.value}
                </p>
                <p className="mt-1 text-xs text-zinc-500 sm:text-sm">
                  {stat.label}
                </p>
              </div>
            ))}
          </div>
        </PageShell>
      </section>

      <section id="features" className="py-16 md:py-20">
        <PageShell>
          <div className="mb-12 text-center">
            <h2 className="text-3xl font-bold text-white md:text-4xl">
              Everything you need
            </h2>
            <p className="mx-auto mt-4 max-w-xl text-zinc-400">
              Built for patients and providers — manage care without juggling
              multiple tools.
            </p>
          </div>
          <div className="grid gap-6 sm:grid-cols-2">
            {features.map((feature) => (
              <Card key={feature.title} hover>
                <span className="text-3xl" aria-hidden>
                  {feature.icon}
                </span>
                <h3 className="mt-4 text-lg font-semibold text-white">
                  {feature.title}
                </h3>
                <p className="mt-2 text-sm leading-relaxed text-zinc-400">
                  {feature.description}
                </p>
              </Card>
            ))}
          </div>
        </PageShell>
      </section>

      <section
        id="how-it-works"
        className="border-y border-surface-500/30 bg-surface-800/30 py-16 md:py-20"
      >
        <PageShell>
          <h2 className="text-center text-3xl font-bold text-white md:text-4xl">
            How it works
          </h2>
          <div className="mt-12 grid gap-8 md:grid-cols-3">
            {steps.map((item) => (
              <div
                key={item.step}
                className="relative text-center md:text-left"
              >
                <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-brand-500/20 text-lg font-bold text-brand-400 md:mx-0">
                  {item.step}
                </div>
                <h3 className="mt-4 text-lg font-semibold text-white">
                  {item.title}
                </h3>
                <p className="mt-2 text-sm text-zinc-400">{item.description}</p>
              </div>
            ))}
          </div>
        </PageShell>
      </section>

      <section id="about" className="py-16 md:py-20">
        <PageShell>
          <Card className="flex flex-col items-center gap-6 text-center md:flex-row md:text-left">
            <div className="flex-1">
              <h2 className="text-2xl font-bold text-white md:text-3xl">
                Ready to take control of your health?
              </h2>
              <p className="mt-3 text-zinc-400">
                Join Medicare+ and experience a modern, secure way to manage
                healthcare records and appointments.
              </p>
            </div>
            <Link href="/auth" className="shrink-0">
              <Button size="lg">Create account</Button>
            </Link>
          </Card>
        </PageShell>
      </section>
    </>
  );
}
