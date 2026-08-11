# flutter_health_connect example

Demonstrates the Health Connect plugin on Android:

1. Availability check
2. Request permissions
3. Display granted permissions
4. Read today's steps
5. Read heart-rate data
6. Read sleep data
7. Aggregate today's activity + daily summary
8. Write test steps
9. Delete the test record
10. Incremental changes sync
11. Open Health Connect settings
12. Open app permissions

## Run

```bash
cd example
flutter run
```

## Device requirements

- Android API 26+
- Health Connect installed (Play Store on Android 13 and lower; system module on Android 14+)
- Grant permissions when prompted

## Privacy policy activity

`PermissionsRationaleActivity` is a placeholder required by Health Connect.
Replace it with your production privacy policy before shipping.
