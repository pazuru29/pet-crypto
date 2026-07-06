import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class CheckAuthStatus {
  final AuthRepository repo;

  CheckAuthStatus({required this.repo});

  Future<Result<AuthSession?>> call() {
    return repo.restoreSession();
  }
}
