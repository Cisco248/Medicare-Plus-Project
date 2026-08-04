import 'package:freezed_annotation/freezed_annotation.dart';

part 'form.model.freezed.dart';

enum FormType { diabetes, hypertenstion, bloodPressure }

@freezed
sealed class FormStatus with _$FormStatus {
  const factory FormStatus({required FormType status}) = _FormStatus;
}
