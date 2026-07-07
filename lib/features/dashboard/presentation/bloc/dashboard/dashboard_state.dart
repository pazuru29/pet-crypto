part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final BlocStatus status;
  final BlocMessage? alertMessage;
  final String? errorMessage;
  final List<Cryptocurrency> listOfCrypto;
  final String? userImage;

  const DashboardState({
    required this.status,
    this.alertMessage,
    this.errorMessage,
    this.listOfCrypto = const [],
    this.userImage,
  });

  const DashboardState.initial() : this(status: .initial);

  DashboardState copyWith({
    BlocStatus? status,
    BlocMessage? alertMessageToShow,
    String? errorMessage,
    List<Cryptocurrency>? listOfCrypto,
    String? userImage,
  }) => DashboardState(
    status: status ?? this.status,
    alertMessage: alertMessageToShow,
    errorMessage: errorMessage,
    listOfCrypto: listOfCrypto ?? this.listOfCrypto,
    userImage: userImage ?? this.userImage,
  );

  @override
  List<Object?> get props => [
    status,
    alertMessage,
    errorMessage,
    listOfCrypto,
    userImage,
  ];
}
