library;

export 'package:flutter_health_connect/src/config/configuration.dart';

///  Configuration for [FlutterHealthConnect].
///
/// Logging never writes health record payloads or personally identifiable
/// health information. Keep [enableLogging] disabled in production.
///
/// [enableLogging] to `false`. Health records, tokens, and PII are never logged.
///
/// [enableLogging] enables non-sensitive diagnostic logs only.

class Configuration {
  final bool enableLogging;

  const Configuration({this.enableLogging = false});
}
