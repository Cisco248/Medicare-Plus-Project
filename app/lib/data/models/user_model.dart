import 'package:app/data/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.mobile,
    required super.password,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
    };
  }

  List<String?> toList() {
    return [name, email, mobile, password];
  }

  UserModel fromMap(Map<dynamic, String> data) {
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
      password: data['password'] ?? '',
    );
  }

  UserModel fromList(List<String?> data) {
    return UserModel(
      name: data[0] ?? '',
      email: data[1] ?? '',
      mobile: data[2] ?? '',
      password: data[3] ?? '',
    );
  }

  @override
  String toString() {
    return 'Name: $name, Email: $email, Mobile_Number: $mobile, Password: $password';
  }
}
