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
    String? email = preferencesStorage.getString(AppStorageKeys.emailKey);
    String? fullName = preferencesStorage.getString(AppStorageKeys.fullNameKey);
    String? image = preferencesStorage.getString(AppStorageKeys.imageKey);

    return UserDataModel(fullName: fullName, email: email, image: image);
  }

  @override
  String? fetchUserImage() {
    return preferencesStorage.getString(AppStorageKeys.imageKey);
  }

  @override
  Future<void> saveUserData(UserDataModel model) async {
    final oldEmail = preferencesStorage.getString(AppStorageKeys.emailKey);
    final oldFullName = preferencesStorage.getString(
      AppStorageKeys.fullNameKey,
    );
    final oldImage = preferencesStorage.getString(AppStorageKeys.imageKey);

    try {
      await _optionalStringSave(AppStorageKeys.emailKey, model.email);
      await _optionalStringSave(AppStorageKeys.fullNameKey, model.fullName);
      await _optionalStringSave(AppStorageKeys.imageKey, model.image);
    } catch (e, s) {
      await _userDataRollback({
        AppStorageKeys.emailKey: oldEmail,
        AppStorageKeys.fullNameKey: oldFullName,
        AppStorageKeys.imageKey: oldImage,
      });

      Error.throwWithStackTrace(e, s);
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
        await preferencesStorage.remove(key);
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
      StorageException(
        technicalMessage: 'Failed to clear user data',
        cause: error,
      ),
      stackTrace,
    );
  }

  Future<void> _optionalStringSave(String key, String? value) async {
    if (value == null || value.isEmpty) {
      await preferencesStorage.remove(key);
      return;
    }

    await preferencesStorage.setString(key, value);
  }

  Future<void> _userDataRollback(Map<String, String?> snapshot) async {
    for (final entry in snapshot.entries) {
      try {
        if (entry.value == null) {
          await preferencesStorage.remove(entry.key);
        } else {
          await preferencesStorage.setString(entry.key, entry.value!);
        }
      } catch (rollbackError, rollbackStackTrace) {
        _log.warning(
          'Failed to restore user data snapshot',
          rollbackError,
          rollbackStackTrace,
        );
      }
    }
  }
}
