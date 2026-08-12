import 'package:client/feature/auth/models/auth.scheme.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.response.model.freezed.dart';

@freezed
abstract class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required String token,
    required UserModel data,
  }) = _AuthResponseModel;
}
