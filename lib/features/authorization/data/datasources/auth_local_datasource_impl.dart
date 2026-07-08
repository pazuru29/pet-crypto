import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_session_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SecureStorage secureStorage;
  final PreferencesStorage preferencesStorage;

  AuthLocalDatasourceImpl({
    required this.secureStorage,
    required this.preferencesStorage,
  });

  @override
  Future<AuthSessionModel?> getSession() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    final email = preferencesStorage.getString(AppStorageKeys.emailKey);
    final fullName = preferencesStorage.getString(AppStorageKeys.fullNameKey);
    final image = preferencesStorage.getString(AppStorageKeys.imageKey);

    return AuthSessionModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      fullName: fullName,
      email: email,
      image: image,
    );
  }

  @override
  Future<String?> getAccessToken() {
    return secureStorage.read(AppStorageKeys.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return secureStorage.read(AppStorageKeys.refreshTokenKey);
  }

  @override
  Future<void> saveSession(AuthSessionModel session) async {
    final accessToken = session.accessToken;
    final refreshToken = session.refreshToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw StorageException('Access token is missing');
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      throw StorageException('Refresh token is missing');
    }

    await secureStorage.write(AppStorageKeys.accessTokenKey, accessToken);
    await secureStorage.write(AppStorageKeys.refreshTokenKey, refreshToken);

    await _setOptionalString(AppStorageKeys.emailKey, session.email);
    await _setOptionalString(AppStorageKeys.fullNameKey, session.fullName);
    await _setOptionalString(AppStorageKeys.imageKey, session.image);
  }

  @override
  Future<void> clearSession() async {
    await secureStorage.delete(AppStorageKeys.accessTokenKey);
    await secureStorage.delete(AppStorageKeys.refreshTokenKey);

    await preferencesStorage.remove(AppStorageKeys.emailKey);
    await preferencesStorage.remove(AppStorageKeys.fullNameKey);
    await preferencesStorage.remove(AppStorageKeys.imageKey);
  }

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    await secureStorage.write(
      AppStorageKeys.accessTokenKey,
      tokens.accessToken,
    );
    await secureStorage.write(
      AppStorageKeys.refreshTokenKey,
      tokens.refreshToken,
    );
  }

  Future<void> _setOptionalString(String key, String? value) async {
    if (value == null || value.isEmpty) {
      await preferencesStorage.remove(key);
      return;
    }

    await preferencesStorage.setString(key, value);
  }
}
