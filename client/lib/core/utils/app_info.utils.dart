import 'package:package_info_plus/package_info_plus.dart';

/// Reads version/build from `pubspec.yaml` (`version: 1.0.0+1`).
class AppInfo {
  const AppInfo({
    required this.appName,
    required this.version,
    required this.buildNumber,
  });

  final String appName;
  final String version;
  final String buildNumber;

  String get versionLabel {
    if (buildNumber.isEmpty) return 'Version $version';
    return 'Version $version ($buildNumber)';
  }

  static Future<AppInfo> load() async {
    final package = await PackageInfo.fromPlatform();
    return AppInfo(
      appName: 'MediCare Plus',
      version: package.version,
      buildNumber: package.buildNumber,
    );
  }
}
