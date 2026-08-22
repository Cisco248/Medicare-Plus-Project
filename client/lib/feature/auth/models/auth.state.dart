import 'package:client/feature/auth/models/auth.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.state.freezed.dart';

enum RequestStatus { successful, failed }

enum FormMode { signIn, signUp }

@Freezed(copyWith: true)
abstract class FormStates with _$FormStates {
  const factory FormStates({required FormMode state}) = _FormStates;
}

enum AuthMode { initial, setup, authenticated, unauthenticated }

@Freezed(copyWith: true)
abstract class AuthStates with _$AuthStates {
  const factory AuthStates({required AuthMode state, AuthResponseModel? data}) =
      _AuthStates;
}
