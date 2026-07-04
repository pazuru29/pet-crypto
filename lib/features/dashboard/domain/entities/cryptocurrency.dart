class Cryptocurrency {
  final int id;
  final String name;
  final String symbol;
  final List<CryptocurrencyPrice> prices;

  const Cryptocurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.prices,
  });
}

class CryptocurrencyPrice {
  final String currencyCode;
  final double amount;

  const CryptocurrencyPrice({required this.currencyCode, required this.amount});
}
