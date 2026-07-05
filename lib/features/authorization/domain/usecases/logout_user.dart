import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';

class LogoutUser {
  Future<Result<AuthStatus>> call() async {
    await DI.disposeUserScope();
    return Ok(.unauthorized);
  }
}
