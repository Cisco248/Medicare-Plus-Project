import 'package:client/core/utils/dio.client.dart';
import 'package:client/data/models/response.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:client/feature/e_doc/repository/hypertension.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat.g.dart';

@riverpod
class ChatBotNotify extends _$ChatBotNotify {
  @override
  ResponseModel build() {
    return ResponseModel(
      message: '',
      body: {"prediction": "Generate the answer"},
    );
  }

  Future<void> sendData(HypertensionModel data) async {
    try {
      final res = await HypertensionRepository(
        client: physicalDevice(8000),
      ).sendData(data);
      state = ResponseModel(
        message: res.message,
        body: {"prediction": res.body?["prediction"] ?? ''},
      );
    } catch (e) {
      state = ResponseModel(message: e.toString());
    }
  }
}
