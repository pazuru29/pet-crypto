import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_response.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repo;

  LoginUser({required this.repo});

  Future<Result<AuthStatus>> call(AuthRequest request) async {
    //TODO
    // Result<AuthResponse> response = await repo.login(request);
    await DI.initUserScope();
    return Ok(.authorized);
  }
}
