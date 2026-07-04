part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final BlocStatus status;
  final String? message;
  final List<Cryptocurrency> listOfCrypto;

  const DashboardState({
    required this.status,
    this.message,
    this.listOfCrypto = const [],
  });

  const DashboardState.initial() : this(status: .initial);

  DashboardState copyWith({
    required BlocStatus status,
    String? message,
    List<Cryptocurrency>? listOfCrypto,
  }) => DashboardState(
    status: status,
    message: message,
    listOfCrypto: listOfCrypto ?? this.listOfCrypto,
  );

  @override
  List<Object?> get props => [status, message, listOfCrypto];
}
