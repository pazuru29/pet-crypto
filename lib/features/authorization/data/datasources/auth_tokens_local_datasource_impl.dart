import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';

class AuthTokensLocalDatasourceImpl implements AuthTokensLocalDatasource {
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
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  Future<String?> fetchAccessToken() async {
    try {
      return await secureStorage.read(AppStorageKeys.accessTokenKey);
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  Future<String?> fetchRefreshToken() async {
    try {
      return await secureStorage.read(AppStorageKeys.refreshTokenKey);
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
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await secureStorage.delete(AppStorageKeys.accessTokenKey);
      await secureStorage.delete(AppStorageKeys.refreshTokenKey);
    } catch (_) {
      throw StorageException('Something went wrong');
    }
  }
}
