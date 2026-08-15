import 'package:client/feature/dashboard/repository/activity_repository.dart';
import 'package:client/feature/dashboard/services/health_connect.service.dart';
import 'package:flutter_health_connect/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppPermissionKind { healthConnect, fileAccess }

enum AppPermissionStatus { allowed, notAllowed, required, unavailable }

class AppPermissionItem {
  const AppPermissionItem({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final AppPermissionKind kind;
  final String title;
  final String subtitle;
  final AppPermissionStatus status;

  String get statusLabel => switch (status) {
    AppPermissionStatus.allowed => 'Allowed',
    AppPermissionStatus.notAllowed => 'Not allowed',
    AppPermissionStatus.required => 'Required',
    AppPermissionStatus.unavailable => 'Unavailable',
  };
}

class PermissionsNotifier extends AsyncNotifier<List<AppPermissionItem>> {
  @override
  Future<List<AppPermissionItem>> build() => _load();

  Future<List<AppPermissionItem>> _load() async {
    var healthStatus = AppPermissionStatus.unavailable;
    try {
      final service = ref.read(healthConnectServiceProvider);
      final availability = await service.availability();
      if (availability == Availability.notInstalled ||
          availability == Availability.notSupported) {
        healthStatus = AppPermissionStatus.unavailable;
      } else {
        final result = await service.checkPermissions(
          ActivityRepository.readPermissions,
        );
        healthStatus = result.granted.isEmpty
            ? AppPermissionStatus.notAllowed
            : AppPermissionStatus.allowed;
      }
    } catch (_) {
      healthStatus = AppPermissionStatus.unavailable;
    }

    return [
      AppPermissionItem(
        kind: AppPermissionKind.healthConnect,
        title: 'Health Connect',
        subtitle: 'Used to read activity and vital signs on the dashboard.',
        status: healthStatus,
      ),
      const AppPermissionItem(
        kind: AppPermissionKind.fileAccess,
        title: 'Storage / file access',
        subtitle:
            'Requested only when you upload or download a medical document.',
        status: AppPermissionStatus.required,
      ),
    ];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> manageHealthConnect() async {
    await ref.read(activityRepositoryProvider).openPermissionSettings();
    await refresh();
  }

  Future<void> requestHealthConnect() async {
    await ref.read(activityRepositoryProvider).requestPermissions();
    await refresh();
  }
}

final permissionsProvider =
    AsyncNotifierProvider<PermissionsNotifier, List<AppPermissionItem>>(
      PermissionsNotifier.new,
    );
