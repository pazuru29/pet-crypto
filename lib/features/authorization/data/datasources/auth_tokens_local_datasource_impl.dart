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
    try {
      final accessToken = await fetchAccessToken();
      final refreshToken = await fetchRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return null;
      }

      return AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } on StorageException {
      rethrow;
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  Future<String?> fetchAccessToken() async {
    try {
      return await secureStorage.read(AppStorageKeys.accessTokenKey);
    } on StorageException {
      rethrow;
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  Future<String?> fetchRefreshToken() async {
    try {
      return await secureStorage.read(AppStorageKeys.refreshTokenKey);
    } on StorageException {
      rethrow;
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    try {
      final accessToken = tokens.accessToken;
      final refreshToken = tokens.refreshToken;

      if (accessToken == null || accessToken.isEmpty) {
        throw StorageException('Access token is missing');
      }

      if (refreshToken == null || refreshToken.isEmpty) {
        throw StorageException('Refresh token is missing');
      }

      await secureStorage.write(AppStorageKeys.accessTokenKey, accessToken);
      await secureStorage.write(AppStorageKeys.refreshTokenKey, refreshToken);
    } on StorageException {
      rethrow;
    } catch (_) {
      throw StorageException('Something went wrong');
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
      StorageException('Failed to clear auth tokens'),
      stackTrace,
    );
  }
}
