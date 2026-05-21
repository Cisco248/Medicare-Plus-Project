export function formatAppVersion(version: string): string {
  return version.startsWith("v") ? version : `v${version}`;
}
