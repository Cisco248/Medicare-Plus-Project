import 'package:flutter/material.dart';
import 'package:flutter_health_connect/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HealthConnectExampleApp());
}

class HealthConnectExampleApp extends StatelessWidget {
  const HealthConnectExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Connect Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E4F)),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final _healthConnect = FlutterHealthConnect(
    config: const Configuration(enableLogging: false),
  );

  String _output = 'Tap an action to begin.';
  bool _busy = false;
  String? _lastWrittenRecordId;
  ChangesToken? _changesToken;

  static final _demoPermissions = [
    Permission.steps.read,
    Permission.steps.write,
    Permission.heartRate.read,
    Permission.heartRate.write,
    Permission.sleepSession.read,
    Permission.activeCaloriesBurned.read,
    Permission.distance.read,
    Permission.weight.read,
    Permission.weight.write,
  ];

  @override
  void initState() {
    super.initState();
    _run('Initialize', () async {
      await _healthConnect.initialize();
      return 'Initialized.';
    });
  }

  Future<void> _run(String label, Future<String> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _output = 'Running: $label…';
    });
    try {
      final message = await action();
      if (!mounted) return;
      setState(() => _output = '[$label]\n$message');
    } on HealthConnectException catch (error) {
      if (!mounted) return;
      setState(() => _output = '[$label] Error\n$error');
    } catch (error) {
      if (!mounted) return;
      setState(() => _output = '[$label] Unexpected error\n$error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  DateTime get _todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _todayEnd => _todayStart.add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Connect Example')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(_output, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _btn(
                      '1. Availability',
                      () => _run('Availability', () async {
                        final availability = await _healthConnect
                            .getAvailability();
                        return 'Availability: $availability';
                      }),
                    ),
                    _btn(
                      '2. Request permissions',
                      () => _run('Request permissions', () async {
                        final granted = await _healthConnect.requestPermissions(
                          [Permission(recordType: RecordType.steps, access: AccessType.read), Permission(recordType: RecordType.totalCaloriesBurned, access: AccessType.read)],
                        );
                        return '$granted';
                      }),
                    ),
                    _btn(
                      '3. Granted permissions',
                      () => _run('Granted permissions', () async {
                        final granted = await _healthConnect
                            .getGrantedPermissions();
                        if (granted.isEmpty) {
                          return 'No permissions granted.';
                        }
                        return granted
                            .map((p) => '${p.recordType.name}.${p.access.name}')
                            .join('\n');
                      }),
                    ),
                    _btn(
                      "4. Today's steps",
                      () => _run('Today steps', () async {
                        final steps = await _healthConnect.readSteps(
                          startTime: _todayStart.toUtc(),
                          endTime: _todayEnd.toUtc(),
                        );
                        final total = steps.fold<int>(
                          0,
                          (sum, r) => sum + r.count,
                        );
                        return 'Records: ${steps.length}\nTotal steps: $total';
                      }),
                    ),
                    _btn(
                      '5. Heart rate',
                      () => _run('Heart rate', () async {
                        final records = await _healthConnect.readHeartRate(
                          startTime: _todayStart.toUtc(),
                          endTime: _todayEnd.toUtc(),
                        );
                        final samples = records.fold<int>(
                          0,
                          (sum, r) => sum + r.samples.length,
                        );
                        return 'Records: ${records.length}\nSamples: $samples';
                      }),
                    ),
                    _btn(
                      '6. Sleep',
                      () => _run('Sleep', () async {
                        final sessions = await _healthConnect.readSleepSessions(
                          startTime: _todayStart
                              .subtract(const Duration(days: 1))
                              .toUtc(),
                          endTime: _todayEnd.toUtc(),
                        );
                        if (sessions.isEmpty) return 'No sleep sessions.';
                        return sessions
                            .map(
                              (s) =>
                                  '${s.startTime.toLocal()} → ${s.endTime.toLocal()} '
                                  '(${s.duration.inMinutes} min, stages=${s.stages.length})',
                            )
                            .join('\n');
                      }),
                    ),
                    _btn(
                      '7. Aggregate today',
                      () => _run('Aggregate', () async {
                        final steps = await _healthConnect.aggregate(
                          metric: Metric.stepsTotal,
                          startTime: _todayStart.toUtc(),
                          endTime: _todayEnd.toUtc(),
                        );
                        final distance = await _healthConnect.aggregate(
                          metric: Metric.distanceTotal,
                          startTime: _todayStart.toUtc(),
                          endTime: _todayEnd.toUtc(),
                        );
                        final calories = await _healthConnect.aggregate(
                          metric: Metric.activeCaloriesTotal,
                          startTime: _todayStart.toUtc(),
                          endTime: _todayEnd.toUtc(),
                        );
                        final summary = await _healthConnect
                            .getDailyHealthSummary(date: DateTime.now());
                        return 'Steps total: ${steps.value}\n'
                            'Distance m: ${distance.value}\n'
                            'Active kcal: ${calories.value}\n'
                            'Summary sleep: ${summary.sleepDuration}';
                      }),
                    ),
                    _btn(
                      '8. Write test steps',
                      () => _run('Write steps', () async {
                        final end = DateTime.now().toUtc();
                        final start = end.subtract(const Duration(minutes: 5));
                        final id = await _healthConnect.writeSteps(
                          count: 120,
                          startTime: start,
                          endTime: end,
                        );
                        _lastWrittenRecordId = id;
                        return 'Wrote steps record id: $id';
                      }),
                    ),
                    _btn(
                      '9. Delete test record',
                      () => _run('Delete record', () async {
                        final id = _lastWrittenRecordId;
                        if (id == null) {
                          return 'Write a test record first.';
                        }
                        await _healthConnect.deleteRecord(
                          type: RecordType.steps,
                          recordId: id,
                        );
                        _lastWrittenRecordId = null;
                        return 'Deleted record $id';
                      }),
                    ),
                    _btn(
                      '10. Incremental changes',
                      () => _run('Changes', () async {
                        _changesToken ??= await _healthConnect.getChangesToken(
                          recordTypes: [RecordType.steps, RecordType.heartRate],
                        );
                        final changes = await _healthConnect.getChanges(
                          _changesToken!,
                        );
                        _changesToken = changes.nextChangesToken;
                        return 'Upserts: ${changes.upsertedRecords.length}\n'
                            'Deletes: ${changes.deletedRecordIds.length}\n'
                            'Expired: ${changes.changesTokenExpired}\n'
                            'Has more: ${changes.hasMore}';
                      }),
                    ),
                    _btn(
                      '11. Open settings',
                      () => _run('Settings', () async {
                        await _healthConnect.openHealthConnectSettings();
                        return 'Opened Health Connect settings.';
                      }),
                    ),
                    _btn(
                      '12. Open app permissions',
                      () => _run('App permissions', () async {
                        await _healthConnect.openAppPermissions();
                        return 'Opened app permissions screen.';
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_busy) const LinearProgressIndicator(minHeight: 3),
        ],
      ),
    );
  }

  Widget _btn(String label, VoidCallback onPressed) {
    return FilledButton.tonal(
      onPressed: _busy ? null : onPressed,
      child: Text(label),
    );
  }
}
