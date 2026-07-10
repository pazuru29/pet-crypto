import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class AuthCheckStatus {
  final AuthRepository repo;

  const AuthCheckStatus({required this.repo});

  Future<Result<bool>> call() async {
    Result<AuthTokens?> response = await repo.restoreSession();

    switch (response) {
      case Ok(value: final session):
        if (session == null) {
          return Ok(false);
        }
        final userResponse = await repo.updateCurrentUser();
        switch (userResponse) {
          case Ok():
            return Ok(true);
          case Err(failure: final error):
            return Err(error);
        }

      case Err(failure: final error):
        return Err(error);
    }
  }
}
