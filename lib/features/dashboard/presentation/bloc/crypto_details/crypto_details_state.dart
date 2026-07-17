part of 'crypto_details_bloc.dart';

class CryptoDetailsState extends Equatable {
  final BlocStatus status;
  final AppErrorCode? errorCode;
  final BlocMessage? alertMessage;
  final CryptoInfo? info;

  const CryptoDetailsState({
    required this.status,
    this.errorCode,
    this.alertMessage,
    this.info,
  });

  const CryptoDetailsState.initial() : this(status: .initial);

  CryptoDetailsState copyWith({
    BlocStatus? status,
    AppErrorCode? errorCode,
    BlocMessage? alertToShow,
    CryptoInfo? info,
  }) => CryptoDetailsState(
    status: status ?? this.status,
    errorCode: errorCode,
    alertMessage: alertToShow,
    info: info ?? this.info,
  );

  @override
  List<Object?> get props => [status, errorCode, alertMessage, info];
}
