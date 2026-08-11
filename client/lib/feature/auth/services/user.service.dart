import 'package:client/core/utils/dio.client.dart';
import 'package:client/feature/auth/models/user_model.dart';
import 'package:client/feature/auth/repository/user.repository.dart';

class UserService {
  final _repo = UserRepository(client: physicalDevice(8080));

  Future<String> loginService(String email, String password) async {
    try {
      final token = await _repo.getOne(email, password);
      if (token == '') return '';
      return token;
    } catch (e) {
      throw Exception('SignIn: $e');
    }
  }

  Future<void> registerService(UserModel data) async {
    try {
      await _repo.addOne(data);
      return;
    } catch (e) {
      throw Exception('SignUp: $e');
    }
  }
}
