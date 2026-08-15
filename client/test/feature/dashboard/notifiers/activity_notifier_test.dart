import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/knowledge.state.model.dart';
import 'package:client/feature/dashboard/notifiers/activity.notifier.dart';
import 'package:client/feature/dashboard/repository/activity_repository.dart';
import 'package:client/feature/dashboard/repository/knowledge.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes.dart';

void main() {
  late FakeActivityRepository activityRepository;
  late FakeKnowledgeRepository knowledgeRepository;
  late ProviderContainer container;

  setUp(() {
    activityRepository = FakeActivityRepository();
    knowledgeRepository = FakeKnowledgeRepository();
    container = ProviderContainer(
      overrides: [
        activityRepositoryProvider.overrideWith((ref) => activityRepository),
        knowledgeRepositoryProvider.overrideWith((ref) => knowledgeRepository),
        authenticationProvider.overrideWith(FakeAuthenticationNotifier.new),
      ],
    );
    addTearDown(container.dispose);
  });

  HealthDataResult grantedResult(ActivityModel activity) =>
      HealthDataResult(status: HealthAccessStatus.granted, activity: activity);

  group('initial load', () {
    test('starts in loadingHealthData for the current local day', () {
      activityRepository.onCollect = () async =>
          grantedResult(sampleActivity());

      final state = container.read(activityProvider);

      expect(state.phase, KnowledgePhase.loadingHealthData);
      expect(state.isLoadingHealthData, isTrue);
      final now = DateTime.now();
      expect(state.periodStart, DateTime(now.year, now.month, now.day));
      expect(
        state.periodEnd.difference(state.periodStart),
        const Duration(days: 1),
      );
    });

    test('transitions to healthDataReady on success', () async {
      final activity = sampleActivity();
      activityRepository.onCollect = () async => grantedResult(activity);

      final notifier = container.read(activityProvider.notifier);
      await notifier.loadHealthData();

      final state = container.read(activityProvider);
      expect(state.phase, KnowledgePhase.healthDataReady);
      expect(state.activity, activity);
      expect(state.hasHealthData, isTrue);
      expect(state.hasError, isFalse);
    });

    test(
      'transitions to noHealthData when the period has no records',
      () async {
        activityRepository.onCollect = () async =>
            grantedResult(ActivityModel(date: DateTime(2026, 8, 14)));

        final notifier = container.read(activityProvider.notifier);
        await notifier.loadHealthData();

        expect(
          container.read(activityProvider).phase,
          KnowledgePhase.noHealthData,
        );
      },
    );

    test('transitions to permissionRequired when access is denied', () async {
      activityRepository.onCollect = () async => const HealthDataResult(
        status: HealthAccessStatus.denied,
        deniedMetrics: ['steps', 'heartRate'],
      );

      final notifier = container.read(activityProvider.notifier);
      await notifier.loadHealthData();

      final state = container.read(activityProvider);
      expect(state.phase, KnowledgePhase.permissionRequired);
      expect(state.needsPermission, isTrue);
      expect(state.unavailableMetrics, ['steps', 'heartRate']);
    });

    test(
      'transitions to healthConnectUnavailable when not installed',
      () async {
        activityRepository.onCollect = () async =>
            const HealthDataResult(status: HealthAccessStatus.unavailable);

        final notifier = container.read(activityProvider.notifier);
        await notifier.loadHealthData();

        expect(container.read(activityProvider).isUnavailable, isTrue);
      },
    );

    test('maps Health Connect failures to a friendly error state', () async {
      activityRepository.onCollect = () async => throw const ForbiddenException(
        message: 'Health Connect access has not been granted.',
      );

      final notifier = container.read(activityProvider.notifier);
      await notifier.loadHealthData();

      final state = container.read(activityProvider);
      expect(state.phase, KnowledgePhase.failure);
      expect(state.errorMessage, 'Health Connect access has not been granted.');
    });
  });

  group('generateSummary', () {
    Future<ActivityNotifier> readyNotifier() async {
      activityRepository.onCollect = () async =>
          grantedResult(sampleActivity());
      final notifier = container.read(activityProvider.notifier);
      await notifier.loadHealthData();
      return notifier;
    }

    test('stores the RAG summary on success', () async {
      final notifier = await readyNotifier();
      knowledgeRepository.onGenerate = () async => sampleSummary();

      await notifier.generateSummary();

      final state = container.read(activityProvider);
      expect(state.phase, KnowledgePhase.summaryReady);
      expect(state.hasSummary, isTrue);
      expect(
        state.summary!.summary,
        'Your activity level has been steady today.',
      );
    });

    test('reuses the cached summary for unchanged health data', () async {
      final notifier = await readyNotifier();
      knowledgeRepository.onGenerate = () async => sampleSummary();

      await notifier.generateSummary();
      await notifier.generateSummary();

      expect(knowledgeRepository.generateCalls, 1);
    });

    test('regenerates when forced', () async {
      final notifier = await readyNotifier();
      knowledgeRepository.onGenerate = () async => sampleSummary();

      await notifier.generateSummary();
      await notifier.generateSummary(force: true);

      expect(knowledgeRepository.generateCalls, 2);
    });

    test('surfaces RAG failures as a friendly error state', () async {
      final notifier = await readyNotifier();
      knowledgeRepository.onGenerate = () async =>
          throw const NetworkException();

      await notifier.generateSummary();

      final state = container.read(activityProvider);
      expect(state.phase, KnowledgePhase.failure);
      expect(state.errorMessage, 'No internet connection.');
      expect(state.hasHealthData, isTrue, reason: 'health data is kept');
    });

    test('retry after a RAG failure regenerates the summary', () async {
      final notifier = await readyNotifier();
      knowledgeRepository.onGenerate = () async =>
          throw const NetworkException();
      await notifier.generateSummary();

      knowledgeRepository.onGenerate = () async => sampleSummary();
      await notifier.retry();

      expect(
        container.read(activityProvider).phase,
        KnowledgePhase.summaryReady,
      );
    });

    test('does nothing when no health data was collected', () async {
      activityRepository.onCollect = () async =>
          const HealthDataResult(status: HealthAccessStatus.denied);
      final notifier = container.read(activityProvider.notifier);
      await notifier.loadHealthData();

      await notifier.generateSummary();

      expect(knowledgeRepository.generateCalls, 0);
      expect(
        container.read(activityProvider).phase,
        KnowledgePhase.permissionRequired,
      );
    });
  });

  group('refresh and permissions', () {
    test('refresh invalidates the cached summary', () async {
      activityRepository.onCollect = () async =>
          grantedResult(sampleActivity());
      knowledgeRepository.onGenerate = () async => sampleSummary();
      final notifier = container.read(activityProvider.notifier);
      await notifier.loadHealthData();
      await notifier.generateSummary();

      await notifier.refresh();

      final state = container.read(activityProvider);
      expect(state.hasSummary, isFalse);
      expect(state.phase, KnowledgePhase.healthDataReady);
    });

    test('requestPermissions reloads health data afterwards', () async {
      activityRepository.onCollect = () async =>
          const HealthDataResult(status: HealthAccessStatus.denied);
      final notifier = container.read(activityProvider.notifier);
      await notifier.loadHealthData();

      activityRepository.onCollect = () async =>
          grantedResult(sampleActivity());
      await notifier.requestPermissions();

      expect(activityRepository.requestPermissionCalls, 1);
      expect(
        container.read(activityProvider).phase,
        KnowledgePhase.healthDataReady,
      );
    });

    test(
      'changePeriod reloads for the new range and clears the summary',
      () async {
        activityRepository.onCollect = () async =>
            grantedResult(sampleActivity());
        knowledgeRepository.onGenerate = () async => sampleSummary();
        final notifier = container.read(activityProvider.notifier);
        await notifier.loadHealthData();
        await notifier.generateSummary();

        final start = DateTime(2026, 8, 10);
        final end = DateTime(2026, 8, 11);
        await notifier.changePeriod(start, end);

        final state = container.read(activityProvider);
        expect(state.periodStart, start);
        expect(state.periodEnd, end);
        expect(state.hasSummary, isFalse);
      },
    );
  });
}
