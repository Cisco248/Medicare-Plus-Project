import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/core/network/dio_client.dart';
import 'package:client/feature/auth/models/auth.model.dart';
import 'package:client/feature/auth/models/auth.state.dart';
import 'package:client/feature/auth/repository/user.repository.dart';

class UserService {
  final _repo = UserRepository(client: client());

  Future<AuthResponseModel> loginService(String email, String password) async {
    try {
      final result = await _repo.getOne(email, password);
      final token = result.token;
      if (token == '') {
        throw NotFoundException(details: token.toString());
      }
      return AuthResponseModel(
        token: token,
        id: result.id,
        name: result.name,
        email: result.email,
        mobnum: result.mobnum,
        password: result.password,
      );
    } catch (e) {
      throw UnknownException(details: e);
    }
  }

  Future<bool> registerService(AuthRequestModel data) async {
    try {
      final result = await _repo.addOne(data);
      if (result == RequestStatus.successful) return true;
      return false;
    } catch (e) {
      throw UnknownException(details: e);
    }
  }

  Future<AuthResponseModel> profileService(String userId, String token) async {
    try {
      final result = await _repo.profile(userId, token);
      return result;
    } catch (e) {
      throw UnknownException(details: e);
    }
  }
}
