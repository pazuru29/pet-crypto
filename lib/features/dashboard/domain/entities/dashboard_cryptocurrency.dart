import 'package:equatable/equatable.dart';

class DashboardCryptocurrency extends Equatable {
  final int id;
  final String name;
  final String symbol;
  final List<DashboardCryptocurrencyPrice> prices;

  const DashboardCryptocurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.prices,
  });

  @override
  List<Object?> get props => [id, name, symbol, prices];
}

class DashboardCryptocurrencyPrice extends Equatable {
  final String currencyCode;
  final double amount;

  const DashboardCryptocurrencyPrice({
    required this.currencyCode,
    required this.amount,
  });

  @override
  List<Object?> get props => [currencyCode, amount];
}
