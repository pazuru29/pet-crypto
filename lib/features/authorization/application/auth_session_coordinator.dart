import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/application/session_scope_controller.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_check_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_logout_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_refresh_token.dart';

class AuthSessionCoordinator {
  final AuthCheckStatus checkAuthStatus;
  final AuthLoginUser loginUser;
  final AuthLogoutUser logoutUser;
  final AuthRefreshToken refreshToken;
  final SessionScopeController sessionScopeController;

  const AuthSessionCoordinator({
    required this.checkAuthStatus,
    required this.loginUser,
    required this.logoutUser,
    required this.refreshToken,
    required this.sessionScopeController,
  });

  Future<Result<AuthSession?>> restoreSession() async {
    final response = await checkAuthStatus.call();

    switch (response) {
      case Ok(value: final session):
        if (session == null) {
          await sessionScopeController.disposeScope();
          return const Ok(null);
        }

        await sessionScopeController.initScope();
        return Ok(session);
      case Err():
        await sessionScopeController.disposeScope();
        return response;
    }
  }

  Future<Result<AuthSession>> login(AuthRequest request) async {
    final response = await loginUser.call(request);

    switch (response) {
      case Ok(value: final session):
        await sessionScopeController.initScope();
        return Ok(session);
      case Err():
        await sessionScopeController.disposeScope();
        return response;
    }
  }

  Future<Result<AuthStatus>> logout() async {
    final response = await logoutUser.call();

    await sessionScopeController.disposeScope();

    return response;
  }

  Future<Result<AuthStatus>> refresh() async {
    final response = await refreshToken.call();

    switch (response) {
      case Ok():
        return response;
      case Err():
        await sessionScopeController.disposeScope();
        return response;
    }
  }
}
