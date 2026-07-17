import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStorageImpl implements PreferencesStorage {
  final SharedPreferences storage;

  const PreferencesStorageImpl({required this.storage});

  @override
  String? getString(String key) {
    try {
      return storage.getString(key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to read string preference',
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  int? getInt(String key) {
    try {
      return storage.getInt(key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to read int preference',
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<void> setString(String key, String value) async {
    try {
      final success = await storage.setString(key, value);

      if (!success) {
        throw StorageException(
          technicalMessage: 'SharedPreferences.setString returned false',
        );
      }
    } on StorageException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to write string preference',
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<void> setInt(String key, int value) async {
    try {
      final success = await storage.setInt(key, value);

      if (!success) {
        throw StorageException(
          technicalMessage: 'SharedPreferences.setInt returned false',
        );
      }
    } on StorageException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to write int preference',
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      final success = await storage.remove(key);

      if (!success) {
        throw StorageException(
          technicalMessage: 'SharedPreferences.remove returned false',
        );
      }
    } on StorageException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to remove preference',
          cause: error,
        ),
        stackTrace,
      );
    }
  }
}
