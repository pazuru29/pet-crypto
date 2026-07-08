part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final BlocStatus status;
  final BlocMessage? alertMessage;
  final String? errorMessage;
  final int currentPaginationStart;
  final int currentPaginationLimit;
  final bool hasNextPage;
  final bool paginationLoading;
  final List<DashboardCryptocurrency> listOfCrypto;
  final String? userImage;

  const DashboardState({
    required this.status,
    this.alertMessage,
    this.errorMessage,
    this.currentPaginationStart = 1,
    this.currentPaginationLimit = 20,
    this.hasNextPage = false,
    this.paginationLoading = false,
    this.listOfCrypto = const [],
    this.userImage,
  });

  const DashboardState.initial() : this(status: .initial);

  DashboardState copyWith({
    BlocStatus? status,
    BlocMessage? alertMessageToShow,
    String? errorMessage,
    int? currentPaginationStart,
    int? currentPaginationLimit,
    bool? hasNextPage,
    bool? paginationLoading,
    List<DashboardCryptocurrency>? listOfCrypto,
    String? userImage,
  }) => DashboardState(
    status: status ?? this.status,
    alertMessage: alertMessageToShow,
    errorMessage: errorMessage,
    currentPaginationStart:
        currentPaginationStart ?? this.currentPaginationStart,
    currentPaginationLimit:
        currentPaginationLimit ?? this.currentPaginationLimit,
    hasNextPage: hasNextPage ?? this.hasNextPage,
    paginationLoading: paginationLoading ?? this.paginationLoading,
    listOfCrypto: listOfCrypto ?? this.listOfCrypto,
    userImage: userImage ?? this.userImage,
  );

  @override
  List<Object?> get props => [
    status,
    alertMessage,
    errorMessage,
    currentPaginationStart,
    currentPaginationLimit,
    hasNextPage,
    paginationLoading,
    listOfCrypto,
    userImage,
  ];
}
