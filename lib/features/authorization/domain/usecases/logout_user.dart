import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repo;

  const LogoutUser({required this.repo});

  Future<Result<AuthStatus>> call() async {
    final response = await repo.clearSession();
    switch (response) {
      case Ok():
        return Ok(.unauthorized);
      case Err(failure: final error):
        return Err(error);
    }
  }
}
