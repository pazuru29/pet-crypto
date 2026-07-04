part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final BlocStatus status;
  final BlocMessage? message;
  final List<Cryptocurrency> listOfCrypto;

  const DashboardState({
    required this.status,
    this.message,
    this.listOfCrypto = const [],
  });

  const DashboardState.initial() : this(status: .initial);

  DashboardState copyWith({
    BlocStatus? status,
    BlocMessage? messageToShow,
    List<Cryptocurrency>? listOfCrypto,
  }) => DashboardState(
    status: status ?? this.status,
    message: messageToShow,
    listOfCrypto: listOfCrypto ?? this.listOfCrypto,
  );

  @override
  List<Object?> get props => [status, message, listOfCrypto];
}
