/// Identifies the application that produced a health record.
/// Creates a data origin.
class HealthDataOrigin {
  const HealthDataOrigin({this.packageName, this.applicationName});

  final String? packageName;
  final String? applicationName;

  factory HealthDataOrigin.fromMap(Map<Object?, Object?> map) {
    return HealthDataOrigin(
      packageName: map['packageName'] as String?,
      applicationName: map['applicationName'] as String?,
    );
  }

  Map<String, Object?> toMap() => {
    'packageName': packageName,
    'applicationName': applicationName,
  };

  @override
  String toString() =>
      'HealthDataOrigin(packageName: $packageName, applicationName: $applicationName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthDataOrigin &&
          packageName == other.packageName &&
          applicationName == other.applicationName;

  @override
  int get hashCode => Object.hash(packageName, applicationName);
}
