# flutter_health_connect

Production-oriented Flutter plugin for **Android Health Connect**, built on the official
[`androidx.health.connect:connect-client`](https://developer.android.com/jetpack/androidx/releases/health-connect) SDK.

> **Android only.** There is no iOS / Apple Health implementation.

## Features

- Availability checks (`SDK_AVAILABLE`, provider update required, unsupported)
- Explicit read/write permission requests (never auto-requested)
- Strongly typed records (steps, heart rate, sleep, body metrics, nutrition, etc.)
- Native aggregation APIs
- Daily health summary helper
- Incremental sync via changes tokens
- Open Health Connect settings / app permissions
- Typed Dart exceptions mapped from Android failures

## Supported Android versions

| Requirement | Value |
|-------------|-------|
| Plugin `minSdk` | 26 |
| Health Connect on Android 14+ | Framework module |
| Health Connect on Android 13 and lower | Play Store app (`com.google.android.apps.healthdata`) |
| Health Connect SDK | `androidx.health.connect:connect-client:1.1.0` (stable) |

Always call `getAvailability()` and handle `notInstalled` / `notSupported` gracefully.

## Installation

```yaml
dependencies:
  flutter_health_connect:
    path: ../flutter_health_connect # or a pub.dev version when published
```

```bash
flutter pub get
```

## Android setup

### 1. Manifest permissions

Declare **only** the Health Connect permissions your app needs:

```xml
<uses-permission android:name="android.permission.health.READ_STEPS"/>
<uses-permission android:name="android.permission.health.WRITE_STEPS"/>
<uses-permission android:name="android.permission.health.READ_HEART_RATE"/>
<!-- add others as needed -->
```

### 2. Package visibility

```xml
<queries>
  <package android:name="com.google.android.apps.healthdata" />
</queries>
```

### 3. Privacy policy activity (required)

Health Connect requires a privacy-policy / rationale activity. See the example app’s
`PermissionsRationaleActivity` and manifest `activity` / `activity-alias` entries.

### 4. Play Console declaration

For Play-distributed apps, declare Health Connect data-type usage in Play Console.

## Initialization

```dart
import 'package:flutter_health_connect/flutter_health_connect.dart';

final healthConnect = FlutterHealthConnect(
  config: const HealthConnectConfig(enableLogging: false),
);

await healthConnect.initialize();

final availability = await healthConnect.getAvailability();
if (availability != HealthConnectAvailability.available) {
  // Guide the user to install/update Health Connect, or hide the feature.
}
```

## Permissions

```dart
final permissions = [
  HealthPermission.steps.read,
  HealthPermission.heartRate.read,
  HealthPermission.activeCaloriesBurned.read,
];

final granted = await healthConnect.requestPermissions(permissions);
final status = await healthConnect.checkPermissions(permissions);
final allGranted = await healthConnect.getGrantedPermissions();
```

## Reading records

All `DateTime` arguments for read/write/aggregate/delete/changes are treated as
**UTC instants** (converted via `toUtc().millisecondsSinceEpoch`).

```dart
final steps = await healthConnect.readSteps(
  startTime: startUtc,
  endTime: endUtc,
);

final heartRate = await healthConnect.readHeartRate(
  startTime: startUtc,
  endTime: endUtc,
);

final sleep = await healthConnect.readSleepSessions(
  startTime: startUtc,
  endTime: endUtc,
);

final generic = await healthConnect.readRecords(
  type: HealthRecordType.weight,
  startTime: startUtc,
  endTime: endUtc,
);
```

## Writing records

Requires the matching **write** permission. Never writes without an explicit call.

```dart
final id = await healthConnect.writeSteps(
  count: 120,
  startTime: startUtc,
  endTime: endUtc,
);
```

## Aggregation

Uses Health Connect’s native aggregate APIs (does not sum by downloading every record).

```dart
final result = await healthConnect.aggregate(
  metric: HealthMetric.stepsTotal,
  startTime: todayStartUtc,
  endTime: todayEndUtc,
);
print(result.value);
```

## Daily summary

```dart
final summary = await healthConnect.getDailyHealthSummary(
  date: DateTime.now(), // local calendar day on device
);
```

There is **no BMI field** — Health Connect has no first-class BMI record type.

## Incremental synchronization

```dart
final token = await healthConnect.getChangesToken(
  recordTypes: [
    HealthRecordType.steps,
    HealthRecordType.heartRate,
  ],
);

final changes = await healthConnect.getChanges(token);
if (changes.changesTokenExpired) {
  // Obtain a new token and perform a full resync.
}
```

## Settings

```dart
await healthConnect.openHealthConnectSettings();
await healthConnect.openAppPermissions();
```

## Error handling

```dart
try {
  await healthConnect.readSteps(startTime: start, endTime: end);
} on HealthConnectPermissionException catch (e) {
  // Request permissions again.
} on HealthConnectNotInstalledException catch (e) {
  // Prompt install/update.
} on HealthConnectException catch (e) {
  // Handle other typed failures.
}
```

## Privacy and security

- Logging is **off** by default (`HealthConnectConfig(enableLogging: false)`).
- The plugin never logs health record payloads or tokens.
- The plugin does not store or upload health data; the host app decides persistence/sync.
- Request only the permissions your product needs.

## Limitations

- Android only
- No BMI record type (not in Health Connect API)
- Sleep stages are nested inside `SleepSessionRecord`
- Feature availability can vary by Health Connect / Android version
- Integration tests that talk to a real Health Connect store require an emulator/device with Health Connect installed and user-granted permissions

## Example application

See [`example/`](example/) for a UI covering availability, permissions, read/write,
aggregation, delete, changes sync, and settings.

```bash
cd example
flutter run
```

## Tests

Dart unit tests (no device required):

```bash
flutter test
```

Kotlin unit tests (from the example Android project):

```bash
cd example/android
./gradlew :flutter_health_connect:testDebugUnitTest
```

On Windows:

```bat
cd example\android
gradlew.bat :flutter_health_connect:testDebugUnitTest
```

## Troubleshooting

| Symptom | What to check |
|---------|----------------|
| `notSupported` | Device Android version too old / work profile limitations |
| `notInstalled` | Install/update Health Connect from Play Store (Android 13-) |
| Permission UI never appears | Manifest missing `uses-permission` for requested types; Activity available |
| Privacy policy link broken | Missing rationale activity / Android 14 `activity-alias` |
| Empty reads | Permissions granted? Data written by another app? Time range in UTC? |

## License

See [LICENSE](LICENSE).
