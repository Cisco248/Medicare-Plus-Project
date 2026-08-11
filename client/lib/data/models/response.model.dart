import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.model.freezed.dart';

@freezed
sealed class ResponseModel with _$ResponseModel {
  const factory ResponseModel({String? message, Map? body}) = _ResponseModel;
}
