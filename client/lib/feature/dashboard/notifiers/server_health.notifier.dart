import 'dart:async';

import 'package:client/core/configs/config.dart';
import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/network/dio_client.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/auth/services/token.service.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/server_health.model.dart';
import 'package:client/feature/dashboard/models/weekly_health.model.dart';
import 'package:client/feature/dashboard/repository/har_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final harRepositoryProvider = Provider<HarRepository>(
  (ref) => HarRepository(client: client()),
);

final serverDailySummaryProvider = FutureProvider<ServerDailySummary?>((
  ref,
) async {
  final auth = ref.watch(authenticationProvider).value?.data;
  if (auth == null || auth.token.isEmpty) return null;
  try {
    return await ref
        .read(harRepositoryProvider)
        .dailySummary(token: auth.token, day: DateTime.now());
  } catch (_) {
    return null;
  }
});

class ServerPredictionViewState {
  const ServerPredictionViewState({
    this.items = const [],
    this.loading = false,
    this.refreshing = false,
    this.errorMessage,
  });

  final List<ServerPrediction> items;
  final bool loading;
  final bool refreshing;
  final String? errorMessage;

  ServerPrediction? get latest => items.firstOrNull;

  ServerPredictionViewState copyWith({
    List<ServerPrediction>? items,
    bool? loading,
    bool? refreshing,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ServerPredictionViewState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ServerPredictionNotifier extends Notifier<ServerPredictionViewState> {
  int _generation = 0;

  @override
  ServerPredictionViewState build() {
    ref.listen(authenticationProvider, (_, next) {
      unawaited(_load());
    });
    unawaited(_load());
    return const ServerPredictionViewState(loading: true);
  }

  Future<String?> _token() async {
    final session = ref.read(authenticationProvider).asData?.value.data?.token;
    if (session != null && session.isNotEmpty) return session;
    return UserTokenService().getTokenKey(userTokenKey);
  }

  Future<void> _load() async {
    final id = ++_generation;
    final token = await _token();
    if (token == null || token.isEmpty) {
      if (id != _generation) return;
      state = const ServerPredictionViewState();
      return;
    }
    try {
      final items = await ref
          .read(harRepositoryProvider)
          .predictions(token: token);
      if (id != _generation) return;
      state = ServerPredictionViewState(items: items);
    } on AppException catch (error) {
      if (id != _generation) return;
      state = state.copyWith(
        loading: false,
        refreshing: false,
        errorMessage: error.message,
      );
    } catch (_) {
      if (id != _generation) return;
      state = state.copyWith(
        loading: false,
        refreshing: false,
        errorMessage: 'Unable to load risk indicators.',
      );
    }
  }

  Future<void> refreshNow() async {
    if (state.refreshing) return;
    final token = await _token();
    if (token == null || token.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Sign in to refresh risk indicators.',
      );
      return;
    }
    final id = ++_generation;
    state = state.copyWith(refreshing: true, clearError: true);
    try {
      final items = await ref
          .read(harRepositoryProvider)
          .refreshPredictions(token: token);
      if (id != _generation) return;
      state = ServerPredictionViewState(items: items);
    } on AppException catch (error) {
      if (id != _generation) return;
      state = state.copyWith(refreshing: false, errorMessage: error.message);
    } catch (_) {
      if (id != _generation) return;
      state = state.copyWith(
        refreshing: false,
        errorMessage: 'Unable to refresh risk indicators.',
      );
    }
  }
}

final serverPredictionProvider =
    NotifierProvider<ServerPredictionNotifier, ServerPredictionViewState>(
      ServerPredictionNotifier.new,
    );

final weeklyHealthProvider = FutureProvider<WeeklyHealthOverview?>((ref) async {
  final auth = ref.watch(authenticationProvider).value?.data;
  if (auth == null || auth.token.isEmpty) return null;
  try {
    return await ref
        .read(harRepositoryProvider)
        .weeklyOverview(
          token: auth.token,
          timezone: DateTime.now().timeZoneName,
          end: DateTime.now(),
        );
  } on AppException catch (error) {
    debugPrint('weeklyHealthProvider failed code=${error.code}');
    rethrow;
  } catch (_) {
    debugPrint('weeklyHealthProvider failed');
    rethrow;
  }
});

final stepsTrendProvider = FutureProvider<HealthTrend?>((ref) async {
  final auth = ref.watch(authenticationProvider).value?.data;
  if (auth == null || auth.token.isEmpty) return null;
  try {
    return await ref
        .read(harRepositoryProvider)
        .trends(token: auth.token, metric: 'steps');
  } catch (_) {
    return null;
  }
});

class HarSyncService {
  const HarSyncService(this._repository);

  final HarRepository _repository;

  Future<void> syncIfPossible({
    required String? token,
    required String? userId,
    required ActivityModel? activity,
  }) async {
    if (token == null || token.isEmpty || userId == null || activity == null) {
      return;
    }
    if (!activity.hasAnyData) return;
    await _repository.submitActivity(
      token: token,
      userId: userId,
      activity: activity,
      day: activity.date,
      timezone: DateTime.now().timeZoneName,
    );
  }
}
