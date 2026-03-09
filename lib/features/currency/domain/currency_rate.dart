import 'package:hive/hive.dart';

part 'currency_rate.g.dart';

@HiveType(typeId: 20)
class CurrencyRate extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String symbol;

  @HiveField(3)
  final double exchangeRate; // Rate relative to USD

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final String? flag; // Country flag emoji

  CurrencyRate({
    required this.code,
    required this.name,
    required this.symbol,
    required this.exchangeRate,
    required this.updatedAt,
    this.flag,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      flag: json['flag'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'exchangeRate': exchangeRate,
      'updatedAt': updatedAt.toIso8601String(),
      'flag': flag,
    };
  }

  CurrencyRate copyWith({
    String? code,
    String? name,
    String? symbol,
    double? exchangeRate,
    DateTime? updatedAt,
    String? flag,
  }) {
    return CurrencyRate(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      updatedAt: updatedAt ?? this.updatedAt,
      flag: flag ?? this.flag,
    );
  }

  bool isStale() {
    return DateTime.now().difference(updatedAt).inHours > 24;
  }
}

/// Popular currencies with their details
class PopularCurrencies {
  static final List<Map<String, String>> currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$', 'flag': '🇺🇸'},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€', 'flag': '🇪🇺'},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£', 'flag': '🇬🇧'},
    {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹', 'flag': '🇮🇳'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥', 'flag': '🇯🇵'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥', 'flag': '🇨🇳'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$', 'flag': '🇦🇺'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'C\$', 'flag': '🇨🇦'},
    {'code': 'CHF', 'name': 'Swiss Franc', 'symbol': 'CHF', 'flag': '🇨🇭'},
    {'code': 'AED', 'name': 'UAE Dirham', 'symbol': 'د.إ', 'flag': '🇦🇪'},
  ];
}
