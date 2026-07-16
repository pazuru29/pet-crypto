import 'package:logging/logging.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:pet_crypto/features/user/data/datasources/user_local_datasource.dart';
import 'package:pet_crypto/features/user/data/models/user_data_model.dart';

class UserLocalDatasourceImpl implements UserLocalDatasource {
  static final Logger _log = Logger('UserLocalDatasourceImpl');

  final PreferencesStorage preferencesStorage;

  const UserLocalDatasourceImpl({required this.preferencesStorage});

  @override
  UserDataModel fetchUserData() {
    try {
      String? email = preferencesStorage.getString(AppStorageKeys.emailKey);
      String? fullName = preferencesStorage.getString(
        AppStorageKeys.fullNameKey,
      );
      String? image = preferencesStorage.getString(AppStorageKeys.imageKey);

      return UserDataModel(fullName: fullName, email: email, image: image);
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  String? fetchUserImage() {
    try {
      return preferencesStorage.getString(AppStorageKeys.imageKey);
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  Future<void> saveUserData(UserDataModel model) async {
    try {
      await _optionalStringSave(AppStorageKeys.emailKey, model.email);
      await _optionalStringSave(AppStorageKeys.fullNameKey, model.fullName);
      await _optionalStringSave(AppStorageKeys.imageKey, model.image);
    } on StorageException {
      rethrow;
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  Future<void> clearUserData() async {
    ({Object error, StackTrace stackTrace})? firstError;

    for (final key in [
      AppStorageKeys.emailKey,
      AppStorageKeys.fullNameKey,
      AppStorageKeys.imageKey,
    ]) {
      try {
        final removed = await preferencesStorage.remove(key);

        if (!removed) {
          throw StorageException('Failed to clear user data');
        }
      } catch (error, stackTrace) {
        firstError ??= (error: error, stackTrace: stackTrace);
        _log.warning('Failed to delete user data', error, stackTrace);
      }
    }

    if (firstError == null) {
      return;
    }

    final (:error, :stackTrace) = firstError;

    if (error is StorageException) {
      Error.throwWithStackTrace(error, stackTrace);
    }

    Error.throwWithStackTrace(
      StorageException('Failed to clear user data'),
      stackTrace,
    );
  }

  Future<void> _optionalStringSave(String key, String? value) async {
    if (value == null || value.isEmpty) {
      await preferencesStorage.remove(key);
      return;
    }

    final success = await preferencesStorage.setString(key, value);
    if (!success) {
      throw StorageException('Failed to save user data');
    }
  }
}
