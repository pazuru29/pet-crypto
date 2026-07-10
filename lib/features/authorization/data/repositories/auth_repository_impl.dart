import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
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
    try {
      final response = await remote.login(AuthRequestModel.fromEntity(request));

      AuthTokens session = response.toAuthTokensEntity();

      await localTokens.saveTokens(AuthTokensModel.fromEntity(session));

      UserData userData = response.toUserDataEntity();

      await localUser.saveUserData(UserDataModel.fromEntity(userData));

      return Ok(session);
    } on ServerException {
      return Err(RemoteFailure('Authorization service unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(ParsingFailure('Failed to process authorization data'));
    } on StorageException catch (e) {
      return Err(StorageFailure(e.message));
    } catch (e) {
      return Err(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateCurrentUser() async {
    try {
      final response = await remote.fetchCurrentUser();

      UserData userData = response.toUserDataEntity();

      await localUser.saveUserData(UserDataModel.fromEntity(userData));

      return Ok(null);
    } on ServerException {
      return Err(RemoteFailure('Authorization service unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(ParsingFailure('Failed to process authorization data'));
    } on StorageException catch (e) {
      return Err(StorageFailure(e.message));
    } catch (e) {
      return Err(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> refreshToken() async {
    try {
      String? token = await localTokens.fetchRefreshToken();

      if (token == null) {
        throw StorageException('RefreshToken is missing');
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

      return Ok(null);
    } on StorageException catch (e) {
      return Err(StorageFailure(e.message));
    } on ServerException {
      return Err(RemoteFailure('Authorization service unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(ParsingFailure('Failed to process authorization data'));
    } catch (e) {
      return Err(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<AuthTokens?>> restoreSession() async {
    try {
      final session = await localTokens.fetchTokens();

      if (session == null) {
        return const Ok(null);
      }

      return Ok(session.toEntity());
    } on ParsingException {
      return Err(ParsingFailure('Failed to process session data'));
    } catch (e) {
      return Err(UnexpectedFailure('Failed to restore session'));
    }
  }

  @override
  Future<Result<void>> clearSession() async {
    try {
      await localTokens.clearTokens();
      await localUser.clearUserData();
      return const Ok(null);
    } catch (e) {
      return Err(UnexpectedFailure('Failed to clear session'));
    }
  }
}
