part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final BlocMessage? alertMessage;
  final AuthStatus authStatus;

  const AuthState({
    required this.status,
    this.authStatus = .unknown,
    this.errorMessage,
    this.alertMessage,
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
    errorMessage: errorMessage,
    alertMessage: alertToShow,
  );

  @override
  List<Object?> get props => [status, authStatus, errorMessage, alertMessage];
}
