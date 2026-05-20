export type Feature = {
  title: string;
  description: string;
  icon: string;
};

export type Stat = {
  value: string;
  label: string;
};

export type LandingContent = {
  hero: {
    badge: string;
    title: string;
    highlight: string;
    description: string;
  };
  features: Feature[];
  steps: { step: number; title: string; description: string }[];
  stats: Stat[];
};

export function getLandingContent(): LandingContent {
  return {
    hero: {
      badge: "Final Year Project · Healthcare Platform",
      title: "Healthcare made",
      highlight: "simple & secure",
      description:
        "Medicare+ connects patients, doctors, and records in one place. Manage appointments, prescriptions, and medical history with confidence.",
    },
    features: [
      {
        icon: "📋",
        title: "Digital Health Records",
        description:
          "Store and access medical history, lab results, and prescriptions securely in one profile.",
      },
      {
        icon: "📅",
        title: "Smart Scheduling",
        description:
          "Book, reschedule, and get reminders for appointments with participating clinics.",
      },
      {
        icon: "💊",
        title: "Prescription Tracking",
        description:
          "Track medications, dosages, and refill dates with clear alerts and history.",
      },
      {
        icon: "🔒",
        title: "Privacy First",
        description:
          "Role-based access and encrypted data handling designed for healthcare compliance.",
      },
    ],
    steps: [
      {
        step: 1,
        title: "Create your account",
        description: "Register as a patient or healthcare provider in minutes.",
      },
      {
        step: 2,
        title: "Complete your profile",
        description: "Add medical history, allergies, and emergency contacts.",
      },
      {
        step: 3,
        title: "Manage care",
        description: "Book visits, view records, and stay on top of your health.",
      },
    ],
    stats: [
      { value: "24/7", label: "Record access" },
      { value: "100%", label: "Digital workflows" },
      { value: "1", label: "Unified platform" },
    ],
  };
}
