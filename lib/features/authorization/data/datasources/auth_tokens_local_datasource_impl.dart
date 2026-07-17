import 'package:logging/logging.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';

class AuthTokensLocalDatasourceImpl implements AuthTokensLocalDatasource {
  static final Logger _log = Logger('AuthTokensLocalDatasourceImpl');

  final SecureStorage secureStorage;

  AuthTokensLocalDatasourceImpl({required this.secureStorage});

  @override
  Future<AuthTokensModel?> fetchTokens() async {
    final accessToken = await fetchAccessToken();
    final refreshToken = await fetchRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return AuthTokensModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<String?> fetchAccessToken() async {
    return await secureStorage.read(AppStorageKeys.accessTokenKey);
  }

  @override
  Future<String?> fetchRefreshToken() async {
    return await secureStorage.read(AppStorageKeys.refreshTokenKey);
  }

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    final accessToken = tokens.accessToken;
    final refreshToken = tokens.refreshToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw StorageException(technicalMessage: 'Access token is missing');
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      throw StorageException(technicalMessage: 'Refresh token is missing');
    }

    final oldAccessToken = await secureStorage.read(
      AppStorageKeys.accessTokenKey,
    );
    final oldRefreshToken = await secureStorage.read(
      AppStorageKeys.refreshTokenKey,
    );

    try {
      await secureStorage.write(AppStorageKeys.accessTokenKey, accessToken);
      await secureStorage.write(AppStorageKeys.refreshTokenKey, refreshToken);
    } catch (e, s) {
      await _tokensRollback({
        AppStorageKeys.accessTokenKey: oldAccessToken,
        AppStorageKeys.refreshTokenKey: oldRefreshToken,
      });
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  Future<void> clearTokens() async {
    ({Object error, StackTrace stackTrace})? firstError;

    for (final key in [
      AppStorageKeys.accessTokenKey,
      AppStorageKeys.refreshTokenKey,
    ]) {
      try {
        await secureStorage.delete(key);
      } catch (error, stackTrace) {
        firstError ??= (error: error, stackTrace: stackTrace);
        _log.warning('Failed to delete auth token', error, stackTrace);
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
        technicalMessage: 'Failed to clear auth tokens',
        cause: error,
      ),
      stackTrace,
    );
  }

  Future<void> _tokensRollback(Map<String, String?> snapshot) async {
    for (final entry in snapshot.entries) {
      try {
        if (entry.value == null) {
          await secureStorage.delete(entry.key);
        } else {
          await secureStorage.write(entry.key, entry.value!);
        }
      } catch (rollbackError, rollbackStackTrace) {
        _log.warning(
          'Failed to restore auth token snapshot',
          rollbackError,
          rollbackStackTrace,
        );
      }
    }
  }
}
