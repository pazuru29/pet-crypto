import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_request_model.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_response.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_response.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<Result<AuthResponse>> login(AuthRequest request) async {
    try {
      final response = await remote.login(AuthRequestModel.fromEntity(request));
      return Ok(response.toEntity());
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
  Future<Result<AuthRefreshResponse>> refreshToken(
    AuthRefreshRequest request,
  ) async {
    try {
      final response = await remote.refreshToken(
        AuthRefreshRequestModel.fromEntity(request),
      );
      return Ok(response.toEntity());
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
}
