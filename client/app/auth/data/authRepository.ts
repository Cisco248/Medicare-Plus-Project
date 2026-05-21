import { apiClient } from "@/lib/api/client";

export type RegisterPayload = {
  fname: string;
  lname: string;
  email: string;
  mobnum: string;
  password: string;
  conpassword: string;
};

export type LoginPayload = {
  email: string;
  password: string;
};

export type AuthUser = {
  id: string;
  fname: string;
  lname: string;
  email: string;
  mobnum: string;
};

export type LoginResponse = {
  token: string;
  user: AuthUser;
};

const TOKEN_STORAGE_KEY = "medicare_plus_auth_token";

export const authRepository = {
  async register(payload: RegisterPayload): Promise<AuthUser> {
    return apiClient<AuthUser>("/client/register", {
      method: "POST",
      body: payload,
    });
  },

  async login(payload: LoginPayload): Promise<LoginResponse> {
    const response = await apiClient<LoginResponse>("/client/login", {
      method: "POST",
      body: payload,
    });
    if (response?.token) {
      authRepository.setToken(response.token);
    }
    return response;
  },

  async getCurrentUser(): Promise<AuthUser> {
    const token = authRepository.getToken();
    return apiClient<AuthUser>("/client/get-data", {
      method: "GET",
      headers: token ? { "x-auth-token": token } : undefined,
    });
  },

  setToken(token: string): void {
    if (typeof window === "undefined") return;
    window.localStorage.setItem(TOKEN_STORAGE_KEY, token);
  },

  getToken(): string | null {
    if (typeof window === "undefined") return null;
    return window.localStorage.getItem(TOKEN_STORAGE_KEY);
  },

  clearToken(): void {
    if (typeof window === "undefined") return;
    window.localStorage.removeItem(TOKEN_STORAGE_KEY);
  },
};
