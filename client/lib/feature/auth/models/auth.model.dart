import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.model.freezed.dart';
part 'auth.model.g.dart';

@Freezed(toJson: true, fromJson: true, toStringOverride: true)
abstract class AuthRequestModel with _$AuthRequestModel {
  const factory AuthRequestModel({
    required String name,
    required String email,
    required String mobnum,
    required String password,
  }) = _AuthRequestModel;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: true)
abstract class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    @Default('') String token,
    @Default('') String id,
    @Default('') String email,
    @Default('') String name,
    @Default('') String mobnum,
    @Default('') String password,
  }) = _AuthResponseModel;
}
