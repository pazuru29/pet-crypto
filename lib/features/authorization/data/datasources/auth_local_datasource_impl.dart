import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';
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

  static const _accessTokenKey = 'auth.accessToken';
  static const _refreshTokenKey = 'auth.refreshToken';
  static const _emailKey = 'auth.email';
  static const _fullNameKey = 'auth.fullName';
  static const _imageKey = 'auth.image';

  @override
  Future<AuthSessionModel?> getSession() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    final email = preferencesStorage.getString(_emailKey);
    final fullName = preferencesStorage.getString(_fullNameKey);
    final image = preferencesStorage.getString(_imageKey);

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
    return secureStorage.read(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return secureStorage.read(_refreshTokenKey);
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

    await secureStorage.write(_accessTokenKey, accessToken);
    await secureStorage.write(_refreshTokenKey, refreshToken);

    await _setOptionalString(_emailKey, session.email);
    await _setOptionalString(_fullNameKey, session.fullName);
    await _setOptionalString(_imageKey, session.image);
  }

  @override
  Future<void> clearSession() async {
    await secureStorage.delete(_accessTokenKey);
    await secureStorage.delete(_refreshTokenKey);

    await preferencesStorage.remove(_emailKey);
    await preferencesStorage.remove(_fullNameKey);
    await preferencesStorage.remove(_imageKey);
  }

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    await secureStorage.write(_accessTokenKey, tokens.accessToken);
    await secureStorage.write(_refreshTokenKey, tokens.refreshToken);
  }

  Future<void> _setOptionalString(String key, String? value) async {
    if (value == null || value.isEmpty) {
      await preferencesStorage.remove(key);
      return;
    }

    await preferencesStorage.setString(key, value);
  }
}
