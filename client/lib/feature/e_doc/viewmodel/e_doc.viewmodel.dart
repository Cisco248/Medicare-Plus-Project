import 'package:client/data/models/response.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/hypertension.repository.dart';

part 'e_doc.viewmodel.g.dart';

@riverpod
class EDocViewModel extends _$EDocViewModel {
  @override
  ResponseModel build() {
    return ResponseModel(message: '', body: {"data": "Generate the answer"});
  }

  Future<void> sendData(HypertensionModel data) async {
    state = ResponseModel(message: '', body: {});
    try {
      final res = await HypertensionRepository().sendData(data);
      state = ResponseModel(message: res.message, body: res.body);
    } catch (e) {
      state = ResponseModel(
        message: e.toString(),
        body: {"data": e.toString()},
      );
    }
  }
}
