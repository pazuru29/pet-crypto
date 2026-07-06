import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_session_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_response.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource remote;
  final AuthLocalDatasource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Result<AuthSession>> login(AuthRequest request) async {
    try {
      final response = await remote.login(AuthRequestModel.fromEntity(request));

      AuthSession session = response.toEntity();

      await local.saveSession(AuthSessionModel.fromEntity(session));

      await local.saveTokens(AuthTokensModel.fromAuthResponseModel(response));

      return Ok(session);
    } on ServerException {
      return Err(ServerFailure('Server unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(ParsingFailure('Failed to parse cryptocurrency data'));
    } catch (e) {
      return Err(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> refreshToken() async {
    try {
      String? token = await local.getRefreshToken();

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

      await local.saveTokens(tokensModel);

      return Ok(null);
    } on StorageException catch (e) {
      return Err(StorageFailure(e.message));
    } on ServerException {
      return Err(ServerFailure('Server unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(ParsingFailure('Failed to parse cryptocurrency data'));
    } catch (e) {
      return Err(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<AuthSession>> restoreSession() async {
    try {
      final session = await local.getSession();

      if (session == null) {
        throw StorageException('Failed to restore session');
      }

      return Ok(session.toEntity());
    } on ParsingException {
      return Err(ParsingFailure('Failed to parse cryptocurrency data'));
    } on StorageException catch (e) {
      return Err(StorageFailure(e.message));
    } catch (e) {
      return Err(StorageFailure('Failed to restore session'));
    }
  }

  @override
  Future<Result<void>> clearSession() async {
    try {
      await local.clearSession();
      return const Ok(null);
    } catch (e) {
      return Err(StorageFailure('Failed to clear session'));
    }
  }
}
