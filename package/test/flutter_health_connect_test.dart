import 'package:flutter_test/flutter_test.dart';
import 'support/fake_health_connect_platform.dart';
import 'package:flutter_health_connect/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeHealthConnectPlatform fake;
  late FlutterHealthConnect healthConnect;

  setUp(() {
    fake = FakeHealthConnectPlatform();
    HealthConnectPlatform.instance = fake;
    healthConnect = FlutterHealthConnect(platform: fake);
  });

  group('initialization', () {
    test('requires initialize before use', () async {
      expect(
        () => healthConnect.getAvailability(),
        throwsA(isA<HealthConnectUnavailableException>()),
      );
    });

    test('initialize is idempotent', () async {
      await healthConnect.initialize();
      await healthConnect.initialize();
      expect(healthConnect.isInitialized, isTrue);
      expect(fake.initializeCount, 1);
    });
  });

  group('time range validation', () {
    test('rejects invalid read ranges', () async {
      await healthConnect.initialize();
      final start = DateTime.utc(2024, 1, 2);
      final end = DateTime.utc(2024, 1, 1);
      expect(
        () => healthConnect.readSteps(startTime: start, endTime: end),
        throwsA(isA<HealthConnectInvalidTimeRangeException>()),
      );
    });

    test('allows equal times for instantaneous writes', () async {
      await healthConnect.initialize();
      final time = DateTime.utc(2024, 6, 1, 12);
      final id = await healthConnect.writeWeight(
        weightKilograms: 70.5,
        time: time,
      );
      expect(id, isNotEmpty);
      expect(fake.writtenRecords.single, isA<WeightRecord>());
    });

    test('preserves UTC instants across timezone boundaries', () async {
      await healthConnect.initialize();
      // 2024-03-10 02:30 America/New_York DST spring forward boundary in UTC terms.
      final start = DateTime.utc(2024, 3, 10, 6, 30);
      final end = DateTime.utc(2024, 3, 10, 8, 30);
      fake.recordsToReturn = [
        StepsRecord(id: '1', startTime: start, endTime: end, count: 500),
      ];
      final steps = await healthConnect.readSteps(
        startTime: start,
        endTime: end,
      );
      expect(steps.single.startTime.isUtc, isTrue);
      expect(steps.single.startTime, start);
      expect(fake.lastReadStartMillis, start.millisecondsSinceEpoch);
      expect(fake.lastReadEndMillis, end.millisecondsSinceEpoch);
    });
  });

  group('permissions', () {
    test('checkPermissions returns granted subset', () async {
      await healthConnect.initialize();
      fake.grantedPermissions = {Permission.steps.read};
      final status = await healthConnect.checkPermissions([
        Permission.steps.read,
        Permission.heartRate.read,
      ]);
      expect(status.allGranted, isFalse);
      expect(status.granted, [Permission.steps.read]);
      expect(status.denied, [Permission.heartRate.read]);
    });

    test('requestPermissions returns false when denied', () async {
      await healthConnect.initialize();
      fake.grantAllOnRequest = false;
      final granted = await healthConnect.requestPermissions([
        Permission.steps.read,
      ]);
      expect(granted, isFalse);
    });
  });

  group('records', () {
    test('readSteps casts typed records', () async {
      await healthConnect.initialize();
      fake.recordsToReturn = [
        StepsRecord(
          id: 'a',
          startTime: DateTime.utc(2024, 1, 1),
          endTime: DateTime.utc(2024, 1, 1, 1),
          count: 1000,
        ),
      ];
      final steps = await healthConnect.readSteps(
        startTime: DateTime.utc(2024, 1, 1),
        endTime: DateTime.utc(2024, 1, 2),
      );
      expect(steps.single.count, 1000);
    });

    test('deleteRecord rejects empty id', () async {
      await healthConnect.initialize();
      expect(
        () => healthConnect.deleteRecord(type: RecordType.steps, recordId: ''),
        throwsA(isA<HealthConnectRecordException>()),
      );
    });
  });

  group('aggregation and changes', () {
    test('aggregate returns platform value', () async {
      await healthConnect.initialize();
      fake.aggregateValue = 4200;
      final result = await healthConnect.aggregate(
        metric: Metric.stepsTotal,
        startTime: DateTime.utc(2024, 1, 1),
        endTime: DateTime.utc(2024, 1, 2),
      );
      expect(result.value, 4200);
    });

    test('getChangesToken rejects empty types', () async {
      await healthConnect.initialize();
      expect(
        () => healthConnect.getChangesToken(recordTypes: const []),
        throwsA(isA<HealthConnectChangesException>()),
      );
    });

    test('getChanges surfaces expired token', () async {
      await healthConnect.initialize();
      fake.changesExpired = true;
      final token = await healthConnect.getChangesToken(
        recordTypes: [RecordType.steps],
      );
      final changes = await healthConnect.getChanges(token);
      expect(changes.changesTokenExpired, isTrue);
    });
  });

  group('models', () {
    test('Permission equality', () {
      expect(Permission.steps.read, Permission.steps.read);
      expect(Permission.steps.read, isNot(Permission.steps.write));
    });

    test('StepsRecord round-trips through map', () {
      final record = StepsRecord(
        id: 'id-1',
        startTime: DateTime.utc(2024, 5, 1, 10),
        endTime: DateTime.utc(2024, 5, 1, 11),
        count: 250,
        dataOrigin: const HealthDataOrigin(packageName: 'com.example'),
      );
      final restored = StepsRecord.fromMap(record.toMap());
      expect(restored.count, 250);
      expect(restored.dataOrigin?.packageName, 'com.example');
      expect(restored.startTime, record.startTime);
    });

    test('RecordConverter rejects missing type', () {
      expect(
        () => RecordConverter.fromMap({'count': 1}),
        throwsA(isA<HealthConnectUnsupportedRecordException>()),
      );
    });

    test('DailyHealthSummary parses sleep duration', () {
      final summary = DailySummary.fromMap({
        'dateMillis': DateTime(2024, 1, 1).millisecondsSinceEpoch,
        'steps': 100,
        'sleepDurationMillis': 8 * 60 * 60 * 1000,
      });
      expect(summary.steps, 100);
      expect(summary.sleepDuration, const Duration(hours: 8));
    });
  });

  group('exceptions', () {
    test('maps platform permission errors', () async {
      await healthConnect.initialize();
      fake.throwOnRead = const HealthConnectPermissionException(
        'denied',
        code: 'permission_denied',
      );
      expect(
        () => healthConnect.readSteps(
          startTime: DateTime.utc(2024, 1, 1),
          endTime: DateTime.utc(2024, 1, 2),
        ),
        throwsA(isA<HealthConnectPermissionException>()),
      );
    });
  });
}
