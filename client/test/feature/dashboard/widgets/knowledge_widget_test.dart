import 'dart:async';

import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/repository/activity_repository.dart';
import 'package:client/feature/dashboard/repository/knowledge.repository.dart';
import 'package:client/feature/dashboard/widgets/knowledge.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes.dart';

void main() {
  late FakeActivityRepository activityRepository;
  late FakeKnowledgeRepository knowledgeRepository;

  setUp(() {
    activityRepository = FakeActivityRepository();
    knowledgeRepository = FakeKnowledgeRepository();
  });

  Widget app() => ProviderScope(
    overrides: [
      activityRepositoryProvider.overrideWith((ref) => activityRepository),
      knowledgeRepositoryProvider.overrideWith((ref) => knowledgeRepository),
      authenticationProvider.overrideWith(FakeAuthenticationNotifier.new),
    ],
    child: const MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: KnowledgeWidget())),
    ),
  );

  testWidgets('shows a loading indicator while collecting health data', (
    tester,
  ) async {
    final completer = Completer<HealthDataResult>();
    activityRepository.onCollect = () => completer.future;

    await tester.pumpWidget(app());
    await tester.pump();

    expect(find.text('Analyzing your health data...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(
      HealthDataResult(
        status: HealthAccessStatus.granted,
        activity: sampleActivity(),
      ),
    );
    await tester.pumpAndSettle();
  });

  testWidgets('offers to generate a summary once health data is ready', (
    tester,
  ) async {
    activityRepository.onCollect = () async => HealthDataResult(
      status: HealthAccessStatus.granted,
      activity: sampleActivity(),
    );

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Generate summary'), findsOneWidget);
  });

  testWidgets('shows progress and then the AI summary with disclaimer', (
    tester,
  ) async {
    activityRepository.onCollect = () async => HealthDataResult(
      status: HealthAccessStatus.granted,
      activity: sampleActivity(),
    );
    final completer = Completer<void>();
    knowledgeRepository.onGenerate = () async {
      await completer.future;
      return sampleSummary();
    };

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate summary'));
    await tester.pump();

    expect(
      find.text('Generating your personalized summary...'),
      findsOneWidget,
    );

    completer.complete();
    await tester.pumpAndSettle();

    expect(
      find.text('Your activity level has been steady today.'),
      findsOneWidget,
    );
    expect(find.textContaining('Stay hydrated.'), findsOneWidget);
    expect(find.text('Informational only.'), findsOneWidget);
    expect(find.textContaining('Generated on'), findsOneWidget);
  });

  testWidgets('asks for Health Connect access when permission is missing', (
    tester,
  ) async {
    activityRepository.onCollect = () async =>
        const HealthDataResult(status: HealthAccessStatus.denied);

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Grant access'), findsOneWidget);

    // Tapping the button triggers the permission flow and a reload.
    activityRepository.onCollect = () async => HealthDataResult(
      status: HealthAccessStatus.granted,
      activity: sampleActivity(),
    );
    await tester.tap(find.text('Grant access'));
    await tester.pumpAndSettle();

    expect(activityRepository.requestPermissionCalls, 1);
    expect(find.text('Generate summary'), findsOneWidget);
  });

  testWidgets('shows the no-data message for an empty period', (tester) async {
    activityRepository.onCollect = () async => HealthDataResult(
      status: HealthAccessStatus.granted,
      activity: sampleActivity().copyWith(
        steps: null,
        distanceMeters: null,
        activeCalories: null,
        totalCalories: null,
        heartRate: null,
        sleep: null,
      ),
    );

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(
      find.text('No health data available for this period.'),
      findsOneWidget,
    );
  });

  testWidgets('shows a friendly error with retry on failure', (tester) async {
    activityRepository.onCollect = () async => throw StateError('raw');

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    expect(find.textContaining('StateError'), findsNothing);
    expect(
      find.text('Reading your health data failed. Please try again.'),
      findsOneWidget,
    );
  });
}
