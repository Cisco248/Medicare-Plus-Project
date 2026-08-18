import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/feature/e_doc/models/assessment.model.dart';
import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:client/feature/e_doc/repository/edoc_client.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diabetes.repository.g.dart';

@riverpod
DiabetesRepository diabetesRepository(Ref ref) =>
    DiabetesRepository(eDocBaseModelClient());

class DiabetesRepository {
  DiabetesRepository(this._client);

  final Dio _client;

  Future<EDocAssessmentState> predict(DiabetesModel request) async {
    try {
      final response = await _client.post<dynamic>(
        '/diabetes',
        data: request.toJson(),
      );
      return EDocAssessmentState.fromResponse(
        response.data,
        model: EDocPredictionModel.diabetes,
      );
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    } on FormatException {
      throw const UnknownException(
        message: 'The server returned an unexpected response.',
      );
    }
  }
}
