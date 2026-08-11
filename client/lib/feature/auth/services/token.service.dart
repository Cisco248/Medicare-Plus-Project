import 'package:client/core/configs/config.dart';
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
    final currentToken = await getTokenKey();
    if (currentToken == null || currentToken.isEmpty) return false;
    return currentToken == token;
  }

  Future<String?> getTokenKey() async {
    final storage = _storage.init();
    final token = await storage.read(key: userTokenKey);
    if (token == null) return null;
    return token;
  }

  Future<void> setTokenKey(String? token) async {
    final storage = _storage.init();
    try {
      await storage.write(key: userTokenKey, value: token);
    } catch (e) {
      Exception(e);
    }
  }

  Future<void> removeToken() async {
    final storage = _storage.init();
    try {
      await storage.delete(key: userTokenKey);
    } catch (e) {
      Exception(e);
    }
  }
}
