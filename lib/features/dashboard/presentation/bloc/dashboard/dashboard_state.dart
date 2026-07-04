part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final BlocStatus status;
  final BlocMessage? alertMessage;
  final String? errorMessage;
  final List<Cryptocurrency> listOfCrypto;

  const DashboardState({
    required this.status,
    this.alertMessage,
    this.errorMessage,
    this.listOfCrypto = const [],
  });

  const DashboardState.initial() : this(status: .initial);

  DashboardState copyWith({
    BlocStatus? status,
    BlocMessage? alertMessageToShow,
    String? errorMessage,
    List<Cryptocurrency>? listOfCrypto,
  }) => DashboardState(
    status: status ?? this.status,
    alertMessage: alertMessageToShow,
    errorMessage: errorMessage,
    listOfCrypto: listOfCrypto ?? this.listOfCrypto,
  );

  @override
  List<Object?> get props => [status, alertMessage, errorMessage, listOfCrypto];
}
