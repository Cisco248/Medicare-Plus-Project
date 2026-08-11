import 'package:shared_preferences/shared_preferences.dart';

class PrefStorageUtils {
  PrefStorageUtils();

  SharedPreferences? prefs;

  Future<void> initialize() async {
    prefs ??= await SharedPreferences.getInstance();
  }
}
