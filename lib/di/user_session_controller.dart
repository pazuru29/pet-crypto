import 'package:pet_crypto/core/application/session_scope_controller.dart';

class UserSessionController implements SessionScopeController {
  final Future<void> Function() init;
  final Future<void> Function() dispose;

  const UserSessionController({required this.init, required this.dispose});

  @override
  Future<void> initScope() => init();

  @override
  Future<void> disposeScope() => dispose();
}
