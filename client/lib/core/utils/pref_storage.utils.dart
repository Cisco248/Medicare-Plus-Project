import 'package:shared_preferences/shared_preferences.dart';

class PrefStorageUtils {
  PrefStorageUtils();

  SharedPreferences? prefs;

  Future<SharedPreferences> initialize() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs!;
  }

  Future<String?> getString(String key) async {
    final store = await initialize();
    return store.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final store = await initialize();
    return store.setString(key, value);
  }

  Future<bool> remove(String key) async {
    final store = await initialize();
    return store.remove(key);
  }
}
