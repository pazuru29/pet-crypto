import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
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
      case Ok(value: final status):
        emit(state.copyWith(status: .loaded, authStatus: status));
      case Err(failure: final error):
        emit(state.copyWith(status: .loaded, errorMessage: error.message));
    }
  }

  void login(String login, String password) async {
    emit(state.copyWith(status: .loading));
    final response = await loginUser.call(
      AuthRequest(login: login, password: password),
    );

    switch (response) {
      case Ok(value: final status):
        emit(state.copyWith(status: .loaded, authStatus: status));
      case Err(failure: final error):
        emit(
          state.copyWith(
            status: .loaded,
            alertToShow: BlocMessage.error(error.message),
          ),
        );
    }
  }

  void logout() async {
    emit(state.copyWith(status: .loading));
    final response = await logoutUser.call();

    switch (response) {
      case Ok(value: final status):
        emit(state.copyWith(status: .loaded, authStatus: status));
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
        emit(state.copyWith(status: .loaded, authStatus: status));
      case Err(failure: final error):
        emit(
          state.copyWith(
            status: .loaded,
            alertToShow: BlocMessage.error(error.message),
          ),
        );
    }
  }
}
