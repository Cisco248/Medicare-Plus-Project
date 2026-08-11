import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.model.freezed.dart';

@freezed
abstract class ChatResponseModel with _$ChatResponseModel {
  const factory ChatResponseModel({
    required String message,
    required DateTime? createdDate,
  }) = _ChatResponseModel;
}
