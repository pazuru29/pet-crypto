import 'package:logging/logging.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/app_executors.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_response.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/user/data/datasources/user_writer_local_datasource.dart';
import 'package:pet_crypto/features/user/data/models/user_data_model.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  static final Logger _log = Logger('AuthRepositoryImpl');

  final AuthDatasource remote;
  final AuthTokensLocalDatasource localTokens;
  final UserWriterLocalDatasource localUser;

  AuthRepositoryImpl({
    required this.remote,
    required this.localTokens,
    required this.localUser,
  });

  @override
  Future<Result<AuthTokens>> login(AuthRequest request) async {
    return executeRepository(_log, () async {
      final response = await remote.login(AuthRequestModel.fromEntity(request));

      AuthTokens session = response.toAuthTokensEntity();

      UserData userData = response.toUserDataEntity();

      try {
        await localUser.saveUserData(UserDataModel.fromEntity(userData));
        await localTokens.saveTokens(AuthTokensModel.fromEntity(session));
      } catch (error, stackTrace) {
        await _clearLocalSession();

        Error.throwWithStackTrace(error, stackTrace);
      }
      return session;
    });
  }

  @override
  Future<Result<void>> updateCurrentUser() async {
    return executeRepository(_log, () async {
      final response = await remote.fetchCurrentUser();

      UserData userData = response.toUserDataEntity();

      await localUser.saveUserData(UserDataModel.fromEntity(userData));

      return;
    });
  }

  @override
  Future<Result<void>> refreshToken() async {
    return executeRepository(_log, () async {
      String? token = await localTokens.fetchRefreshToken();

      if (token == null || token.isEmpty) {
        throw AuthorizationException(
          .sessionExpired,
          technicalMessage: 'Session has expired. Please log in again',
        );
      }

      AuthRefreshRequest request = AuthRefreshRequest(refreshToken: token);

      final response = await remote.refreshToken(
        AuthRefreshRequestModel.fromEntity(request),
      );

      AuthRefreshResponse result = response.toEntity();

      AuthTokensModel tokensModel = AuthTokensModel(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      await localTokens.saveTokens(tokensModel);

      return;
    });
  }

  @override
  Future<Result<AuthTokens?>> restoreSession() async {
    return executeRepository(_log, () async {
      final session = await localTokens.fetchTokens();

      if (session == null) {
        return null;
      }

      return session.toEntity();
    });
  }

  @override
  Future<Result<void>> clearSession() async {
    return executeRepository(_log, () async {
      final cleanupError = await _clearLocalSession();

      if (cleanupError != null) {
        Error.throwWithStackTrace(cleanupError.error, cleanupError.stackTrace);
      }

      return;
    });
  }

  Future<({Object error, StackTrace stackTrace})?> _clearLocalSession() async {
    ({Object error, StackTrace stackTrace})? firstError;

    try {
      await localTokens.clearTokens();
    } catch (error, stackTrace) {
      firstError = (error: error, stackTrace: stackTrace);
      _log.warning('Failed to clear auth tokens', error, stackTrace);
    }

    try {
      await localUser.clearUserData();
    } catch (error, stackTrace) {
      firstError ??= (error: error, stackTrace: stackTrace);
      _log.warning('Failed to clear user data', error, stackTrace);
    }

    return firstError;
  }
}
