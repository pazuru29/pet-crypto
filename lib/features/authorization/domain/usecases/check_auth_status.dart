import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';

class CheckAuthStatus {
  Future<Result<AuthStatus>> call() async {
    await Future.delayed(Duration(seconds: 1));
    //TODO
    AuthStatus status = .unauthorized;

    if (status == .authorized) {
      await DI.initUserScope();
    }

    return Ok(status);
  }
}
