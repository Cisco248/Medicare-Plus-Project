import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission.model.freezed.dart';
part 'permission.model.g.dart';

enum AppPermissionKind { healthConnect, fileAccess }

enum AppPermissionStatus { allowed, notAllowed, required, unavailable }

@Freezed(toJson: true, fromJson: true, toStringOverride: true)
abstract class AppPermissionItem with _$AppPermissionItem {
  const AppPermissionItem._();

  const factory AppPermissionItem({
    required AppPermissionKind kind,
    required String title,
    required String subtitle,
    required AppPermissionStatus status,
  }) = _AppPermissionItem;

  String get statusLabel => switch (status) {
    AppPermissionStatus.allowed => 'Allowed',
    AppPermissionStatus.notAllowed => 'Not allowed',
    AppPermissionStatus.required => 'Required',
    AppPermissionStatus.unavailable => 'Unavailable',
  };
}
