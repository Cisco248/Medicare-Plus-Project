library;

/// Availability of the Health Connect SDK on the current device.
///
/// Mapped from [HealthConnectClient.getSdkStatus](https://developer.android.com/reference/androidx/health/connect/client/HealthConnectClient).
/// Health Connect APIs are available (`SDK_AVAILABLE`).
///
/// Provider APK is missing or needs an update
/// (`SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED`).
/// Device cannot support Health Connect (`SDK_UNAVAILABLE`).
/// Unexpected status returned by the platform.
///
/// - [available] Health Connect APIs are available (`SDK_AVAILABLE`).
/// - [notInstalled] Provider APK is missing or needs an update
/// (`SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED`).
/// - [notSupported] Device cannot support Health Connect (`SDK_UNAVAILABLE`).
/// - [unknown] Unexpected status returned by the platform.

enum Availability { available, notInstalled, notSupported, unknown }
