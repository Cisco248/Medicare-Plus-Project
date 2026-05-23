import Link from "next/link";
import { getLandingContent } from "@/lib/data/landingRepository";
import { Card } from "@/lib/components/ui/Card";
import { Button } from "@/lib/components/ui/Button";
import { PageShell } from "@/lib/components/shared/PageShell";

export default function LandingPage() {
  const { hero, features, steps, stats } = getLandingContent();

  return (
    <>
      <section className="grid grid-rows-[auto_1fr_auto_auto] h-dvh justify-center py-20">
        <span className="flex justify-self-center items-center rounded-full border border-brand-500/30 bg-brand-500/10 w-fit px-4 py-2 text-xs font-medium text-brand-300">
          {hero.badge}
        </span>

        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top,var(--color-brand-900)_0%,transparent_55%)] opacity-60" />

        <h1 className="justify-self-center py-10 text-4xl font-bold tracking-tight text-white md:text-6xl">
          {hero.title}{" "}
          <span className="bg-linear-to-r from-brand-300 to-brand-500 bg-clip-text text-transparent">
            {hero.highlight}
          </span>
        </h1>

        <p className="py-3 text-lg leading-relaxed text-zinc-400">
          {hero.description}
        </p>

        <div className="py-4 justify-self-center flex flex-wrap gap-4">
          <Link href="/auth">
            <Button size="lg">Get started free</Button>
          </Link>
          <Link href="#features">
            <Button variant="outline" size="lg">
              Explore features
            </Button>
          </Link>
        </div>

        <div className="py-10 grid grid-cols-3 w-full justify-between justify-items-center border-t border-surface-500/40 ">
          {stats.map((stat) => (
            <div key={stat.label}>
              <p className="text-2xl font-bold text-brand-400">{stat.value}</p>
              <p className="mt-1 text-xs text-zinc-500 sm:text-sm">
                {stat.label}
              </p>
            </div>
          ))}
        </div>
      </section>

      <section id="features" className="h-dvh p-20">
        <div className="mb-12 text-center">
          <h2 className="text-3xl font-bold text-white md:text-4xl">
            Everything you need
          </h2>
          <p className="mx-auto mt-4 max-w-xl text-zinc-400">
            Built for patients and providers — manage care without juggling
            multiple tools.
          </p>
        </div>
        <div className="grid gap-x-10 gap-y-10 w-full  grid-cols-2">
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
      </section>

      <section
        id="how-it-works"
        className="flex flex-col justify-center place-self-center w-full h-dvh border-y border-surface-500/30 bg-brand-800/50"
      >
        <h2 className="text-center text-6xl font-bold text-white p-20">
          How it works
        </h2>
        <p className="max-w-2xl mx-auto text-zinc-400 text-center mb-20">
          Lorem ipsum dolor sit amet consectetur, adipisicing elit. Voluptatum
          est in veniam maxime et dolor repudiandae, error facere earum iure
          quos reiciendis pariatur veritatis, tempore ipsam ducimus delectus ex
          recusandae.
        </p>
        <div className=" mt-12 grid grid-cols-3 justify-between justify-items-center w-full gap-x-10 gap-y-10">
          {steps.map((item) => (
            <div
              key={item.step}
              className="relative text-center md:text-left bg-brand-900/50 rounded-2xl p-6 backdrop-blur-sm"
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
      </section>

      <section
        id="about"
        className="flex h-dvh w-full justify-center items-center bg-brand-900/30"
      >
        <div className="flex flex-col items-center gap-6 text-center">
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
        </div>
      </section>
    </>
  );
}
