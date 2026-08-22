import 'package:client/core/configs/config.dart';
import 'package:client/core/constants/text_variables.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/core/utils/pref_storage.utils.dart';

class SetupKeyService {
  final PrefStorageUtils _storage = PrefStorageUtils();

  Future<bool> getupKey() async {
    await _storage.initialize();
    final pref = _storage.prefs;
    if (pref == null) throw UnknownException(details: errorMsg);
    return pref.getBool(isSetupKey) ?? false;
  }

  Future<void> setupKey() async {
    try {
      await _storage.initialize();
      final prefs = _storage.prefs;
      if (prefs == null) throw UnknownException(details: errorMsg);
      await prefs.setBool(isSetupKey, true);
    } catch (e) {
      throw UnknownException(details: e);
    }
  }

  Future<void> setKey(String key, String value) async {
    try {
      final prefs = _storage.prefs;
      if (prefs == null) throw NotFoundException(details: errorMsg);
      await prefs.setString(key, value);
    } catch (e) {
      UnknownException(details: e.toString());
    }
  }

  Future<String> getKey(String key) async {
    await _storage.initialize();
    final pref = _storage.prefs;
    if (pref == null) throw UnknownException(details: errorMsg);
    return pref.getString(key) ?? '';
  }

  Future<void> clearKey() async {
    try {
      await _storage.initialize();
      final prefs = _storage.prefs;
      if (prefs == null) throw UnknownException(details: errorMsg);
      await prefs.remove(isSetupKey);
    } catch (e) {
      UnknownException(details: e);
    }
  }
}
