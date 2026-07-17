part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final BlocStatus status;
  final AppErrorCode? errorCode;
  final BlocMessage? alertMessage;
  final AuthStatus authStatus;

  const AuthState({
    required this.status,
    this.authStatus = .unknown,
    this.errorCode,
    this.alertMessage,
  });

  const AuthState.initial() : this(status: .initial);

  AuthState copyWith({
    BlocStatus? status,
    AuthStatus? authStatus,
    AppErrorCode? errorCode,
    BlocMessage? alertToShow,
  }) => AuthState(
    status: status ?? this.status,
    authStatus: authStatus ?? this.authStatus,
    errorCode: errorCode,
    alertMessage: alertToShow,
  );

  @override
  List<Object?> get props => [status, authStatus, errorCode, alertMessage];
}
