import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repo;

  LoginUser({required this.repo});

  Future<Result<AuthSession>> call(AuthRequest request) {
    return repo.login(request);
  }
}
