import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_response.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_response.dart';

abstract interface class AuthRepository {
  Future<Result<AuthResponse>> login(AuthRequest request);

  Future<Result<AuthRefreshResponse>> refreshToken(AuthRefreshRequest request);
}
