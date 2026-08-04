import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}

@freezed
abstract class UserResponseModel with _$UserResponseModel {
  const factory UserResponseModel({Map? data, String? token}) =
      _UserResponseModel;

  factory UserResponseModel.fromJson(Map<String, Object?> json) =>
      _$UserResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$UserResponseModelToJson(this as _UserResponseModel);
}
