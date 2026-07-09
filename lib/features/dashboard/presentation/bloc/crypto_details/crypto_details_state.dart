part of 'crypto_details_bloc.dart';

class CryptoDetailsState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final BlocMessage? alertMessage;
  final CryptoInfo? info;

  const CryptoDetailsState({
    required this.status,
    this.errorMessage,
    this.alertMessage,
    this.info,
  });

  const CryptoDetailsState.initial() : this(status: .initial);

  CryptoDetailsState copyWith({
    BlocStatus? status,
    String? errorMessage,
    BlocMessage? alertToShow,
    CryptoInfo? info,
  }) => CryptoDetailsState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    alertMessage: alertToShow,
    info: info ?? this.info,
  );

  @override
  List<Object?> get props => [status, errorMessage, alertMessage, info];
}
