import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary_request.model.dart';
import 'package:client/feature/dashboard/models/health_summary_response.model.dart';
import 'package:client/feature/dashboard/services/rag.service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'knowledge.repository.g.dart';

@riverpod
KnowledgeRepository knowledgeRepository(Ref ref) =>
    KnowledgeRepository(ragService: ref.watch(ragServiceProvider));

/// Domain layer between the notifier and the RAG API.
///
/// Builds the structured [HealthSummaryRequest] from normalized activity data
/// and delegates the HTTP call to [RagService]. Refuses to send empty data to
/// the RAG system as if it were real.
class KnowledgeRepository {
  KnowledgeRepository({required this._ragService});

  final RagService _ragService;

  Future<HealthSummaryResponse> generateSummary({
    required ActivityModel activity,
    required DateTime startTime,
    required DateTime endTime,
    String? userId,
    String? token,
  }) async {
    if (!activity.hasAnyData) {
      throw const ValidationException(
        message: 'No health data is available to summarize for this period.',
      );
    }

    final request = HealthSummaryRequest.fromActivity(
      activity: activity,
      startTime: startTime,
      endTime: endTime,
      userId: userId,
    );
    return _ragService.generateHealthSummary(request, token: token);
  }
}
