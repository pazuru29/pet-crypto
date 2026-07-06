import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/core/application/session_scope_controller.dart';

class UserSessionController implements SessionScopeController {
  @override
  Future<void> initScope() => DI.initUserScope();

  @override
  Future<void> disposeScope() => DI.disposeUserScope();
}
