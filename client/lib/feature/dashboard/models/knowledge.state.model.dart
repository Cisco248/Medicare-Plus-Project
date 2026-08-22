import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'knowledge.state.model.freezed.dart';

enum KnowledgePhase {
  loadingHealthData,
  healthConnectUnavailable,
  permissionRequired,
  noHealthData,
  healthDataReady,
  generatingSummary,
  summaryReady,
  failure,
}

@freezed
abstract class KnowledgeState with _$KnowledgeState {
  const KnowledgeState._();

  const factory KnowledgeState({
    required KnowledgePhase phase,
    required DateTime periodStart,
    required DateTime periodEnd,
    ActivityModel? activity,
    HealthSummaryResponse? summary,
    ActivityModel? summarySource,
    String? errorMessage,
    @Default(<String>[]) List<String> unavailableMetrics,
  }) = _KnowledgeState;

  bool get isLoadingHealthData => phase == KnowledgePhase.loadingHealthData;
  bool get isGeneratingSummary => phase == KnowledgePhase.generatingSummary;
  bool get hasHealthData => activity?.hasAnyData ?? false;
  bool get hasSummary => summary != null;
  bool get hasError => phase == KnowledgePhase.failure;
  bool get needsPermission => phase == KnowledgePhase.permissionRequired;
  bool get isUnavailable => phase == KnowledgePhase.healthConnectUnavailable;
  bool get isSummaryUpToDate =>
      summary != null && summarySource != null && summarySource == activity;
}
