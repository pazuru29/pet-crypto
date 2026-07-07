import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class AuthCheckStatus {
  final AuthRepository repo;

  const AuthCheckStatus({required this.repo});

  Future<Result<AuthSession?>> call() {
    return repo.restoreSession();
  }
}
