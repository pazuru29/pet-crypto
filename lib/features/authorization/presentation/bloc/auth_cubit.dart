import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/check_auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/logout_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/refresh_token.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.authStatus,
    required this.loginUser,
    required this.logoutUser,
    required this.refreshToken,
  }) : super(AuthState.initial());

  // UseCases
  final CheckAuthStatus authStatus;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final RefreshToken refreshToken;

  void checkAuthStatus() async {
    emit(state.copyWith(status: .loading));
    final response = await authStatus.call();
    switch (response) {
      case Ok(value: final session):
        if (session == null) {
          emit(state.copyWith(status: .loaded, authStatus: .unauthorized));
          return;
        }

        await _initUserScope(.authorized);
        emit(
          state.copyWith(
            status: .loaded,
            authStatus: .authorized,
            authSession: session,
          ),
        );
      case Err(failure: final error):
        emit(
          state.copyWith(
            status: .loaded,
            errorMessage: error.message,
            authStatus: .unauthorized,
          ),
        );
    }
  }

  void login(String login, String password) async {
    emit(state.copyWith(status: .loading));
    final response = await loginUser.call(
      AuthRequest(login: login, password: password),
    );

    switch (response) {
      case Ok(value: final session):
        await _initUserScope(.authorized);
        emit(
          state.copyWith(
            status: .loaded,
            authStatus: .authorized,
            authSession: session,
          ),
        );
      case Err(failure: final error):
        emit(
          state.copyWith(
            status: .loaded,
            alertToShow: BlocMessage.error(error.message),
            authStatus: .unauthorized,
          ),
        );
    }
  }

  void logout() async {
    emit(state.copyWith(status: .loading));
    final response = await logoutUser.call();

    switch (response) {
      case Ok(value: final status):
        await _disposeUserScope(status);
        emit(
          state.copyWith(
            status: .loaded,
            authStatus: status,
            clearAuthSession: true,
          ),
        );
      case Err(failure: final error):
        emit(
          state.copyWith(
            status: .loaded,
            alertToShow: BlocMessage.error(error.message),
          ),
        );
    }
  }

  void refresh() async {
    emit(state.copyWith(status: .loading));
    final response = await refreshToken.call();

    switch (response) {
      case Ok(value: final status):
        await _disposeUserScope(status);
        emit(state.copyWith(status: .loaded, authStatus: status));
      case Err(failure: final error):
        await _disposeUserScope(.unauthorized);
        emit(
          state.copyWith(
            status: .loaded,
            alertToShow: BlocMessage.error(error.message),
            authStatus: .unauthorized,
          ),
        );
    }
  }

  Future<void> _initUserScope(AuthStatus status) async {
    if (status == .authorized) {
      await DI.initUserScope();
    }
  }

  Future<void> _disposeUserScope(AuthStatus status) async {
    if (status == .unauthorized) {
      await DI.disposeUserScope();
    }
  }
}
