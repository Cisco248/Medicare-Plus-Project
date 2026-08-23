import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.model.freezed.dart';
part 'auth.model.g.dart';

class AuthRequestModel {
  const AuthRequestModel({
    required this.name,
    required this.email,
    required this.birthDay,
    required this.weight,
    required this.height,
    required this.mobnum,
    required this.password,
  });

  final String name;
  final String email;
  final DateTime birthDay;
  final double weight;
  final double height;
  final String mobnum;
  final String password;

  static int ageFrom(DateTime birthDay) {
    final today = DateTime.now();
    var years = today.year - birthDay.year;
    if (today.month < birthDay.month ||
        (today.month == birthDay.month && today.day < birthDay.day)) {
      years -= 1;
    }
    return years;
  }

  int get age => ageFrom(birthDay);

  /// Backend register contract: snake_case profile fields, date-only birthday.
  Map<String, dynamic> toRegisterJson() {
    final day =
        '${birthDay.year.toString().padLeft(4, '0')}-'
        '${birthDay.month.toString().padLeft(2, '0')}-'
        '${birthDay.day.toString().padLeft(2, '0')}';
    return {
      'name': name,
      'email': email,
      'mobnum': mobnum,
      'password': password,
      'date_of_birth': day,
      'height_cm': height,
      'weight_kg': weight,
    };
  }
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

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
