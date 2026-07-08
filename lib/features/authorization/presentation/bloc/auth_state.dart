part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final BlocStatus status;
  final BlocMessage? alertMessage;
  final String? errorMessage;
  final AuthStatus authStatus;

  const AuthState({
    required this.status,
    this.authStatus = .unknown,
    this.alertMessage,
    this.errorMessage,
  });

  const AuthState.initial() : this(status: .initial);

  AuthState copyWith({
    BlocStatus? status,
    AuthStatus? authStatus,
    String? errorMessage,
    BlocMessage? alertToShow,
  }) => AuthState(
    status: status ?? this.status,
    authStatus: authStatus ?? this.authStatus,
    alertMessage: alertToShow,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, authStatus, alertMessage, errorMessage];
}
