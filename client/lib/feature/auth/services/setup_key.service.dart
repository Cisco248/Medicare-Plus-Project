import 'package:client/core/configs/config.dart';
import 'package:client/core/utils/pref_storage.utils.dart';

class SetupKeyService {
  final PrefStorageUtils _storage = PrefStorageUtils();

  Future<bool> getKey() async {
    await _storage.initialize();
    final res = _storage.prefs?.getBool(isSetupKey) ?? false;
    return res;
  }

  Future<void> setKey() async {
    try {
      await _storage.initialize();
      final prefs = _storage.prefs;
      if (prefs == null) throw StateError('Preferences not initialized');
      await prefs.setBool(isSetupKey, true);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> clearKey() async {
    try {
      await _storage.initialize();
      final prefs = _storage.prefs;
      if (prefs == null) throw StateError('Preferences not initialized');
      await prefs.remove(isSetupKey);
    } catch (e) {
      Exception(e);
    }
  }
}
