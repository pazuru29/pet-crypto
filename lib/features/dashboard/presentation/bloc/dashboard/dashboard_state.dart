part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final BlocStatus status;
  final AppErrorCode? errorCode;
  final BlocMessage? alertMessage;
  final int currentPaginationStart;
  final int currentPaginationLimit;
  final bool hasNextPage;
  final bool paginationLoading;
  final List<DashboardCryptocurrency> listOfCrypto;
  final String? userImage;

  const DashboardState({
    required this.status,
    this.alertMessage,
    this.errorCode,
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
    AppErrorCode? errorCode,
    int? currentPaginationStart,
    int? currentPaginationLimit,
    bool? hasNextPage,
    bool? paginationLoading,
    List<DashboardCryptocurrency>? listOfCrypto,
    String? userImage,
  }) => DashboardState(
    status: status ?? this.status,
    alertMessage: alertMessageToShow,
    errorCode: errorCode,
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
    errorCode,
    alertMessage,
    currentPaginationStart,
    currentPaginationLimit,
    hasNextPage,
    paginationLoading,
    listOfCrypto,
    userImage,
  ];
}
