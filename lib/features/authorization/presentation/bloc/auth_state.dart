part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final BlocStatus status;
  final BlocMessage? alertMessage;
  final AuthStatus authStatus;

  const AuthState({
    required this.status,
    this.authStatus = .unknown,
    this.alertMessage,
  });

  const AuthState.initial() : this(status: .initial);

  AuthState copyWith({
    BlocStatus? status,
    AuthStatus? authStatus,
    BlocMessage? alertToShow,
  }) => AuthState(
    status: status ?? this.status,
    authStatus: authStatus ?? this.authStatus,
    alertMessage: alertToShow,
  );

  @override
  List<Object?> get props => [status, authStatus, alertMessage];
}
