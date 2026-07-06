import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repo;

  LoginUser({required this.repo});

  Future<Result<AuthSession>> call(AuthRequest request) async {
    Result<AuthSession> response = await repo.login(request);
    switch (response) {
      case Ok(value: final session):
        return Ok(session);
      case Err(failure: final error):
        return Err(NetworkFailure(error.message));
    }
  }
}
