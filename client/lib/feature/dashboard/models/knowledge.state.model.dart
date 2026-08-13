import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary_response.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'knowledge.state.model.freezed.dart';

/// Lifecycle phase of the Knowledge (health-summary) feature.
enum KnowledgePhase {
  /// Health data is being collected from Health Connect.
  loadingHealthData,

  /// Health Connect is not installed or not supported on this device.
  healthConnectUnavailable,

  /// No read permission has been granted; the user must grant access.
  permissionRequired,

  /// Permissions are fine but no records exist for the selected period.
  noHealthData,

  /// Health data has been collected and a summary can be generated.
  healthDataReady,

  /// The RAG backend is generating the AI summary.
  generatingSummary,

  /// An AI summary is available.
  summaryReady,

  /// Collecting data or generating the summary failed.
  failure,
}

/// UI state of the Knowledge widget.
///
/// The widget only inspects the exposed getters/phase; all transitions are
/// driven by `ActivityNotifier`.
@freezed
abstract class KnowledgeState with _$KnowledgeState {
  const KnowledgeState._();

  const factory KnowledgeState({
    required KnowledgePhase phase,
    required DateTime periodStart,
    required DateTime periodEnd,
    ActivityModel? activity,
    HealthSummaryResponse? summary,

    /// The activity snapshot the current [summary] was generated from,
    /// used to avoid regenerating a summary for unchanged data.
    ActivityModel? summarySource,

    /// User-friendly error description. Never a raw exception/stack trace.
    String? errorMessage,

    /// Names of the metrics the user has not granted access to.
    @Default(<String>[]) List<String> unavailableMetrics,
  }) = _KnowledgeState;

  bool get isLoadingHealthData => phase == KnowledgePhase.loadingHealthData;

  bool get isGeneratingSummary => phase == KnowledgePhase.generatingSummary;

  bool get hasHealthData => activity?.hasAnyData ?? false;

  bool get hasSummary => summary != null;

  bool get hasError => phase == KnowledgePhase.failure;

  bool get needsPermission => phase == KnowledgePhase.permissionRequired;

  bool get isUnavailable => phase == KnowledgePhase.healthConnectUnavailable;

  /// Whether the cached summary still matches the collected health data.
  bool get isSummaryUpToDate =>
      summary != null && summarySource != null && summarySource == activity;
}
