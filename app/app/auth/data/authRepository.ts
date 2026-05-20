import { apiClient } from "@/lib/api/client";
import type { ApiResponse } from "@/lib/types/api";

export async function checkApiHealth(): Promise<ApiResponse> {
  return apiClient<ApiResponse>("/");
}
