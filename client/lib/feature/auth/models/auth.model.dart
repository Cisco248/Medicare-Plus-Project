import 'package:client/feature/auth/models/auth.scheme.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.model.freezed.dart';

enum AuthMode { initial, setup, authenticated, unauthenticated }

@freezed
abstract class AuthStatus with _$AuthStatus {
  const factory AuthStatus({
    required AuthMode state,
    UserModel? data,
    String? token,
  }) = _AuthStatus;
}
