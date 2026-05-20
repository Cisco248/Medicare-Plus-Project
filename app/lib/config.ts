export const config = {
  apiBaseUrl: process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000",
  appName: "Medicare+",
} as const;
