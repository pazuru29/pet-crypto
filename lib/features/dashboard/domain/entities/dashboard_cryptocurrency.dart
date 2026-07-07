class DashboardCryptocurrency {
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
}

class DashboardCryptocurrencyPrice {
  final String currencyCode;
  final double amount;

  const DashboardCryptocurrencyPrice({
    required this.currencyCode,
    required this.amount,
  });
}
