# Implementation Plan - Fix GoRouter Redirection Logic

The current router implementation has syntax errors and logical flaws in the `redirect` function. Specifically, it fails to correctly extract the authentication state from the Riverpod provider and contains uninitialized variables.

## User Review Required

> [!IMPORTANT]
> The proposed changes assume that `AuthStatus` is the class returned by `authenticationProvider` and it contains a `state` field of type `AuthMode`. This matches the definitions found in `auth.model.dart`.

## Proposed Changes

### [Component] Routing

#### [MODIFY] [app.router.dart](file:///home/asus/Desktop/project/Medicare-Plus-Project/client/lib/app.router.dart)
- Fix the `redirect` logic to correctly handle `AsyncValue<AuthStatus>`.
- Remove the uninitialized `AuthStatus` variable and the incorrect `whenData` usage.
- Add guards to prevent infinite redirection loops by checking the current location.
- Ensure proper mapping between `AuthMode` states and route paths.

## Verification Plan

### Manual Verification
- Verify that the app starts at the `/loading` screen if the auth state is being fetched.
- Verify that unauthenticated users are redirected to `/auth`.
- Verify that users who haven't completed setup are redirected to `/splash`.
- Verify that authenticated users are redirected to `/home`.
- Verify that once logged in, navigating back to `/auth` redirects to `/home`.
