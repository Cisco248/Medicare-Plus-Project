import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:client/feature/settings/models/permission.model.dart';
import 'package:flutter_health_connect/app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions.notifier.g.dart';

@riverpod
class PermissionsNotifier extends _$PermissionsNotifier {
  @override
  Future<List<AppPermissionItem>> build() => _load();

  Future<List<AppPermissionItem>> _load() async {
    var healthStatus = AppPermissionStatus.unavailable;
    try {
      final repository = ref.read(activityRepositoryProvider);
      final availability = await repository.getAvailability();
      if (availability == Availability.notInstalled ||
          availability == Availability.notSupported) {
        healthStatus = AppPermissionStatus.unavailable;
      } else {
        final result = await repository.checkReadPermissions();
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
