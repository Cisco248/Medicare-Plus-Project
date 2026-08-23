import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/models/heart_disease.model.dart';
import 'package:client/feature/e_doc/repository/edoc_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final heartDiseaseRepositoryProvider = Provider<HeartDiseaseRepository>(
  (ref) => HeartDiseaseRepository(eDocBaseModelClient()),
);

class HeartDiseaseRepository {
  HeartDiseaseRepository(this._client);

  final Dio _client;

  Future<DocState> predict(HeartDiseaseModel request) async {
    try {
      final response = await _client.post<dynamic>(
        '/heart-disease',
        data: request.toApiJson(),
      );
      return DocState.fromResponse(response.data, model: DocModel.heartDisease);
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    } on FormatException {
      throw const UnknownException(
        message: 'The server returned an unexpected response.',
      );
    }
  }
}
