import 'package:client/feature/dashboard/repository/activity_repository.dart';
import 'package:flutter_health_connect/app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity.notifier.g.dart';

final _repo = ActivityRepository();

List<Permission> _stepsPermission = [
  Permission(recordType: RecordType.steps, access: AccessType.read),
];

List<Permission> _burnCaloryPermission = [
  Permission(
    recordType: RecordType.totalCaloriesBurned,
    access: AccessType.read,
  ),
];

@riverpod
class StepsActivityNotifier extends _$StepsActivityNotifier {
  @override
  Future<int> build() async {
    final records = await _repo.footStep(_stepsPermission);
    return records.fold<int>(0, (count, record) => count + record.count);
  }
}

@riverpod
class BurnCaloriesActivityNotifier extends _$BurnCaloriesActivityNotifier {
  @override
  Future<double> build() async {
    final records = await _repo.burnCalories(_burnCaloryPermission);
    return records.fold<double>(
      0.0,
      (count, record) => count + record.energyKilocalories,
    );
  }
}

@riverpod
class DailyActivityNotifier extends _$DailyActivityNotifier {
  @override
  Future<DailySummary> build() async {
    final records = await _repo.dailySummary();
    return records;
  }
}
