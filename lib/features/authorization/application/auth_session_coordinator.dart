import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/check_auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/logout_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/refresh_token.dart';

class AuthSessionCoordinator {
  final CheckAuthStatus checkAuthStatus;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final RefreshToken refreshToken;
  final Future<void> Function() initUserScope;
  final Future<void> Function() disposeUserScope;

  const AuthSessionCoordinator({
    required this.checkAuthStatus,
    required this.loginUser,
    required this.logoutUser,
    required this.refreshToken,
    required this.initUserScope,
    required this.disposeUserScope,
  });

  Future<Result<AuthSession?>> restoreSession() async {
    final response = await checkAuthStatus.call();

    switch (response) {
      case Ok(value: final session):
        if (session == null) {
          await disposeUserScope();
          return const Ok(null);
        }

        await initUserScope();
        return Ok(session);
      case Err():
        await disposeUserScope();
        return response;
    }
  }

  Future<Result<AuthSession>> login(AuthRequest request) async {
    final response = await loginUser.call(request);

    switch (response) {
      case Ok(value: final session):
        await initUserScope();
        return Ok(session);
      case Err():
        await disposeUserScope();
        return response;
    }
  }

  Future<Result<AuthStatus>> logout() async {
    final response = await logoutUser.call();

    await disposeUserScope();

    return response;
  }

  Future<Result<AuthStatus>> refresh() async {
    final response = await refreshToken.call();

    switch (response) {
      case Ok():
        return response;
      case Err():
        await disposeUserScope();
        return response;
    }
  }
}
