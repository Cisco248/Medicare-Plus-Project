import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/feature/e_doc/models/assessment.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:client/feature/e_doc/repository/edoc_client.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hypertension.repository.g.dart';

@riverpod
HypertensionRepository hypertensionRepository(Ref ref) =>
    HypertensionRepository(eDocBaseModelClient());

class HypertensionRepository {
  HypertensionRepository(this._client);

  final Dio _client;

  Future<EDocAssessmentState> sendData(HypertensionModel data) async {
    try {
      final response = await _client.post<dynamic>(
        '/hypertension',
        data: data.toJson(),
      );
      return EDocAssessmentState.fromResponse(
        response.data,
        model: EDocPredictionModel.hypertension,
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
