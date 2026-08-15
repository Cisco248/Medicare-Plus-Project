import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/core/utils/dio.client.dart';
import 'package:client/feature/auth/models/auth.response.model.dart';
import 'package:client/feature/auth/models/auth.scheme.model.dart';
import 'package:client/feature/auth/repository/user.repository.dart';

class UserService {
  final _repo = UserRepository(client: virtualDevice(8080));

  Future<AuthResponseModel> loginService(String email, String password) async {
    try {
      final result = await _repo.getOne(email, password);
      final token = result.token;
      if (token == '') {
        throw NotFoundException(details: token.toString());
      }
      return AuthResponseModel(token: token, data: result.data);
    } catch (e) {
      throw UnknownException(details: e);
    }
  }

  Future<bool> registerService(UserModel data) async {
    try {
      final result = await _repo.addOne(data);
      if (result == RequestStatus.successful) return true;
      return false;
    } catch (e) {
      throw UnknownException(details: e);
    }
  }
}
