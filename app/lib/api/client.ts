import { config } from "@/lib/config";
import type { ApiResponse } from "@/lib/types/api";

type RequestOptions = {
  method?: "GET" | "POST" | "PUT" | "PATCH" | "DELETE";
  body?: unknown;
  headers?: HeadersInit;
};

export async function apiClient<T = ApiResponse>(
  path: string,
  options: RequestOptions = {},
): Promise<T> {
  const { method = "GET", body, headers } = options;

  const response = await fetch(`${config.apiBaseUrl}${path}`, {
    method,
    headers: {
      "Content-Type": "application/json",
      ...headers,
    },
    body: body ? JSON.stringify(body) : undefined,
  });

  if (!response.ok) {
    throw new Error(`API request failed: ${response.status}`);
  }

  return response.json() as Promise<T>;
}
