import 'package:client/core/exceptions/base.exception.dart';
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
      if (result.token.isEmpty) {
        throw const NotFoundException(message: 'Unable to sign in.');
      }
      return AuthResponseModel(
        token: result.token,
        id: result.id,
        name: result.name,
        email: result.email,
        mobnum: result.mobnum,
        password: '',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(details: e);
    }
  }

  Future<bool> registerService(AuthRequestModel data) async {
    try {
      final result = await _repo.addOne(data);
      return result == RequestStatus.successful;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(details: e);
    }
  }

  Future<AuthResponseModel> profileService(String userId, String token) async {
    try {
      return await _repo.profile(userId, token);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(details: e);
    }
  }
}
