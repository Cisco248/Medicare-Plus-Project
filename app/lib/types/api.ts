export type ApiResponse<T = unknown> = {
  "Status Code": number;
  Title: string;
  Description: string;
  Version: string;
  Message: string;
  data?: T;
};
