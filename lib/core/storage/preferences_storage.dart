abstract interface class PreferencesStorage {
  String? getString(String key);

  int? getInt(String key);

  Future<bool> setString(String key, String value);

  Future<bool> setInt(String key, int value);

  Future<bool> remove(String key);
}
