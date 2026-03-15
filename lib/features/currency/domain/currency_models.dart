// Currency domain models

class CurrencyRate {
  final String code;
  final String name;
  final double rate;
  final String symbol;
  final DateTime lastUpdated;
  final String flag;

  CurrencyRate({
    required this.code,
    required this.name,
    required this.rate,
    required this.symbol,
    required this.lastUpdated,
    this.flag = '🌍',
  });
}
