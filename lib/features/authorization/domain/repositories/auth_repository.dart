import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';

abstract interface class AuthRepository {
  Future<Result<AuthTokens>> login(AuthRequest request);

  Future<Result<void>> refreshToken();

  Future<Result<AuthTokens?>> restoreSession();

  Future<Result<void>> clearSession();
}
