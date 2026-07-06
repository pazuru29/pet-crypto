import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession>> login(AuthRequest request);

  Future<Result<void>> refreshToken();

  Future<Result<AuthSession?>> restoreSession();

  Future<Result<void>> clearSession();
}
