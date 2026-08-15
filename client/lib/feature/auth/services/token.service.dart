import 'package:client/core/configs/config.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/core/utils/secure_storage.utils.dart';

class UserTokenService {
  final SecureLocalStoreUtils _storage = SecureLocalStoreUtils();

  Future<String?> build() async {
    final storage = _storage.init();
    final token = await storage.read(key: userTokenKey);
    return token;
  }

  Future<bool> verifyToken(String token) async {
    if (token.isEmpty) return false;
    final currentToken = await getTokenKey(userTokenKey);
    if (currentToken == null || currentToken.isEmpty) {
      NotFoundException(
        message: 'Your token not found',
        details: token.toString(),
      );
      return false;
    }
    return currentToken == token;
  }

  Future<String?> getTokenKey(String key) async {
    final storage = _storage.init();
    final token = await storage.read(key: key);
    if (token == null) {
      NotFoundException(
        message: 'Your token not found',
        details: token.toString(),
      );
      return null;
    }
    return token;
  }

  Future<void> setTokenKey(String key, String? token) async {
    final storage = _storage.init();
    try {
      if (token == null) throw NotFoundException(details: token.toString());
      await storage.write(key: key, value: token);
    } catch (e) {
      UnknownException(details: e);
    }
  }

  Future<void> removeToken() async {
    final storage = _storage.init();
    try {
      await storage.delete(key: userTokenKey);
    } catch (e) {
      UnknownException(details: e);
    }
  }
}
