import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_check_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_logout_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_refresh_token.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authStatus,
    required this.loginUser,
    required this.logoutUser,
    required this.refreshToken,
  }) : super(AuthState.initial()) {
    on<AuthCheckEvent>(_authCheckEvent);
    on<AuthLoginEvent>(_authLoginEvent, transformer: droppable());
    on<AuthLogoutEvent>(_authLogoutEvent, transformer: droppable());
    on<AuthRefreshTokenEvent>(_authRefreshTokenEvent, transformer: droppable());
  }

  final AuthCheckStatus authStatus;
  final AuthLoginUser loginUser;
  final AuthLogoutUser logoutUser;
  final AuthRefreshToken refreshToken;

  FutureOr<void> _authCheckEvent(
    AuthCheckEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: .loading));

    final response = await authStatus.call();
    switch (response) {
      case Ok(value: final hasSession):
        if (!hasSession) {
          await _unauthorize(emit);
          return;
        }
        await _authorize(emit);
      case Err(failure: final error):
        await _unauthorize(emit, errorMessage: error.message);
    }
  }

  FutureOr<void> _authLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    final response = await loginUser.call(
      AuthRequest(login: event.username, password: event.password),
    );

    switch (response) {
      case Ok():
        await _authorize(emit);
      case Err(failure: final error):
        await _unauthorize(
          emit,
          alertMessage: BlocMessage.error(error.message),
        );
    }
  }

  FutureOr<void> _authLogoutEvent(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    final response = await logoutUser.call();

    switch (response) {
      case Ok(value: final status):
        await _unauthorize(emit, authStatus: status);
      case Err(failure: final error):
        await _unauthorize(
          emit,
          alertMessage: BlocMessage.error(error.message),
        );
    }
  }

  FutureOr<void> _authRefreshTokenEvent(
    AuthRefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    final response = await refreshToken.call();

    switch (response) {
      case Ok(value: final status):
        emit(state.copyWith(status: .loaded, authStatus: status));
      case Err(failure: final error):
        await _unauthorize(
          emit,
          alertMessage: BlocMessage.error(error.message),
        );
    }
  }

  Future<void> _authorize(Emitter<AuthState> emit) async {
    emit(state.copyWith(status: .loaded, authStatus: .authorized));
  }

  Future<void> _unauthorize(
    Emitter<AuthState> emit, {
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
