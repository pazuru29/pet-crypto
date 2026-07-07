import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class AuthRefreshToken {
  final AuthRepository repo;

  const AuthRefreshToken({required this.repo});

  Future<Result<AuthStatus>> call() async {
    Result<void> response = await repo.refreshToken();
    switch (response) {
      case Ok():
        return Ok(.authorized);
      case Err(failure: final error):
        return Err(error);
    }
  }
}
