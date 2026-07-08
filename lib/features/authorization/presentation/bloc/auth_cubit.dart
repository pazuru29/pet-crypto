import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_check_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_logout_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_refresh_token.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.authStatus,
    required this.loginUser,
    required this.logoutUser,
    required this.refreshToken,
  }) : super(AuthState.initial());

  final AuthCheckStatus authStatus;
  final AuthLoginUser loginUser;
  final AuthLogoutUser logoutUser;
  final AuthRefreshToken refreshToken;

  void checkAuthStatus() async {
    emit(state.copyWith(status: .loading));
    final response = await authStatus.call();
    switch (response) {
      case Ok(value: final session):
        if (session == null) {
          await _unauthorize();
          return;
        }

        await _authorize(session);
      case Err(failure: final error):
        await _unauthorize(errorMessage: error.message);
    }
  }

  void login(String login, String password) async {
    emit(state.copyWith(status: .loading));
    final response = await loginUser.call(
      AuthRequest(login: login, password: password),
    );

    switch (response) {
      case Ok(value: final session):
        await _authorize(session);
      case Err(failure: final error):
        await _unauthorize(alertMessage: BlocMessage.error(error.message));
    }
  }

  void logout() async {
    emit(state.copyWith(status: .loading));
    final response = await logoutUser.call();

    switch (response) {
      case Ok(value: final status):
        await _unauthorize(authStatus: status);
      case Err(failure: final error):
        await _unauthorize(alertMessage: BlocMessage.error(error.message));
    }
  }

  void refresh() async {
    emit(state.copyWith(status: .loading));
    final response = await refreshToken.call();

    switch (response) {
      case Ok(value: final status):
        emit(state.copyWith(status: .loaded, authStatus: status));
      case Err(failure: final error):
        await _unauthorize(alertMessage: BlocMessage.error(error.message));
    }
  }

  Future<void> _authorize(AuthTokens session) async {
    emit(state.copyWith(status: .loaded, authStatus: .authorized));
  }

  Future<void> _unauthorize({
    AuthStatus authStatus = AuthStatus.unauthorized,
    BlocMessage? alertMessage,
    String? errorMessage,
  }) async {
    emit(
      state.copyWith(
        status: .loaded,
        authStatus: authStatus,
        alertToShow: alertMessage,
        errorMessage: errorMessage,
      ),
    );
  }
}
