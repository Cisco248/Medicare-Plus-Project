import 'package:freezed_annotation/freezed_annotation.dart';

part 'form.model.freezed.dart';

enum FormMode { signIn, signUp }

@freezed
abstract class FormStatus with _$FormStatus {
  const factory FormStatus({required FormMode state}) = _FormStatus;
}
