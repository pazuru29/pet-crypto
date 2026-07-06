part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final BlocStatus status;
  final BlocMessage? alertMessage;
  final String? errorMessage;
  final AuthStatus authStatus;
  final AuthSession? authSession;

  const AuthState({
    required this.status,
    this.authStatus = .unknown,
    this.alertMessage,
    this.errorMessage,
    this.authSession,
  });

  const AuthState.initial() : this(status: .initial);

  AuthState copyWith({
    BlocStatus? status,
    AuthStatus? authStatus,
    String? errorMessage,
    BlocMessage? alertToShow,
    AuthSession? authSession,
    bool clearAuthSession = false,
  }) => AuthState(
    status: status ?? this.status,
    authStatus: authStatus ?? this.authStatus,
    alertMessage: alertToShow,
    errorMessage: errorMessage,
    authSession: clearAuthSession ? null : authSession ?? this.authSession,
  );

  @override
  List<Object?> get props => [
    status,
    authStatus,
    alertMessage,
    errorMessage,
    authSession,
  ];
}
