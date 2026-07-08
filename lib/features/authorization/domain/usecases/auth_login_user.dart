import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class AuthLoginUser {
  final AuthRepository repo;

  const AuthLoginUser({required this.repo});

  Future<Result<AuthTokens>> call(AuthRequest request) {
    return repo.login(request);
  }
}
