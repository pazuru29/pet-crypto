import 'package:pet_crypto/core/storage/preferences_storage.dart';

class InMemoryPreferencesStorage implements PreferencesStorage {
  final Map<String, Object> _values;

  InMemoryPreferencesStorage({Map<String, Object> initialValues = const {}})
    : _values = Map.from(initialValues);

  @override
  int? getInt(String key) {
    final value = _values[key];

    if (value is! int?) {
      throw TypeError();
    }

    return value;
  }

  @override
  String? getString(String key) {
    final value = _values[key];

    if (value is! String?) {
      throw TypeError();
    }

    return value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    _values[key] = value;
  }

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }
}
