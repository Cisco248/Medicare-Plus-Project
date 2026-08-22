import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary.model.dart';
import 'package:client/feature/dashboard/services/rag.service.dart';

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
