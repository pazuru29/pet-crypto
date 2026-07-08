part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthCheckEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String username;
  final String password;

  AuthLoginEvent({required this.username, required this.password});
}

class AuthLogoutEvent extends AuthEvent {}

class AuthRefreshTokenEvent extends AuthEvent {}
