import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStorageImpl implements PreferencesStorage {
  final SharedPreferences storage;

  const PreferencesStorageImpl({required this.storage});

  @override
  String? getString(String key) {
    return storage.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    return await storage.setString(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    return await storage.remove(key);
  }
}
