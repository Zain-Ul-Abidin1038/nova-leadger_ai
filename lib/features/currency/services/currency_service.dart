// Currency service
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/currency_models.dart';

class CurrencyService {
  DateTime? lastUpdate;
  List<CurrencyRate> _cachedRates = [];

  Future<void> initialize() async {
    _cachedRates = await getRates();
  }

  bool needsUpdate() {
    if (lastUpdate == null) return true;
    final hoursSinceUpdate = DateTime.now().difference(lastUpdate!).inHours;
    return hoursSinceUpdate >= 24;
  }

  Future<List<CurrencyRate>> getRates() async {
    // Mock implementation - replace with real API
    lastUpdate = DateTime.now();
    _cachedRates = [
      CurrencyRate(
        code: 'USD',
        name: 'US Dollar',
        rate: 1.0,
        symbol: '\$',
        lastUpdated: DateTime.now(),
        flag: '🇺🇸',
      ),
      CurrencyRate(
        code: 'EUR',
        name: 'Euro',
        rate: 0.85,
        symbol: '€',
        lastUpdated: DateTime.now(),
        flag: '🇪🇺',
      ),
      CurrencyRate(
        code: 'GBP',
        name: 'British Pound',
        rate: 0.73,
        symbol: '£',
        lastUpdated: DateTime.now(),
        flag: '🇬🇧',
      ),
      CurrencyRate(
        code: 'INR',
        name: 'Indian Rupee',
        rate: 83.12,
        symbol: '₹',
        lastUpdated: DateTime.now(),
        flag: '🇮🇳',
      ),
    ];
    return _cachedRates;
  }

  List<CurrencyRate> getAllRates() {
    return _cachedRates;
  }

  DateTime? getLastUpdateTime() {
    return lastUpdate;
  }

  String formatAmount(double amount, String currencyCode) {
    final rate = _cachedRates.firstWhere(
      (r) => r.code == currencyCode,
      orElse: () => CurrencyRate(
        code: currencyCode,
        name: currencyCode,
        rate: 1.0,
        symbol: '\$',
        lastUpdated: DateTime.now(),
      ),
    );
    return '${rate.symbol}${amount.toStringAsFixed(2)}';
  }

  double? getRate(String currencyCode) {
    try {
      return _cachedRates.firstWhere((r) => r.code == currencyCode).rate;
    } catch (e) {
      return null;
    }
  }

  double convert(double amount, String from, String to) {
    final fromRate = getRate(from) ?? 1.0;
    final toRate = getRate(to) ?? 1.0;
    return (amount / fromRate) * toRate;
  }
}

final currencyServiceProvider = Provider((ref) => CurrencyService());

// Currency Converter State
class CurrencyConverterState {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final bool isLoading;
  final double? convertedAmount;

  CurrencyConverterState({
    this.fromCurrency = 'USD',
    this.toCurrency = 'EUR',
    this.amount = 0.0,
    this.isLoading = false,
    this.convertedAmount,
  });

  CurrencyConverterState copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    bool? isLoading,
    double? convertedAmount,
  }) {
    return CurrencyConverterState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      isLoading: isLoading ?? this.isLoading,
      convertedAmount: convertedAmount ?? this.convertedAmount,
    );
  }
}

// Currency Converter Controller
class CurrencyConverterController {
  final CurrencyService _service;
  CurrencyConverterState _state = CurrencyConverterState();

  CurrencyConverterController(this._service);

  CurrencyConverterState get state => _state;

  void setFromCurrency(String currency) {
    _state = _state.copyWith(fromCurrency: currency);
  }

  void setToCurrency(String currency) {
    _state = _state.copyWith(toCurrency: currency);
  }

  void setAmount(double amount) {
    _state = _state.copyWith(amount: amount);
  }

  void swapCurrencies() {
    _state = _state.copyWith(
      fromCurrency: _state.toCurrency,
      toCurrency: _state.fromCurrency,
    );
  }

  Future<void> updateRates() async {
    _state = _state.copyWith(isLoading: true);
    await _service.getRates();
    _state = _state.copyWith(isLoading: false);
  }
}

final currencyConverterProvider = Provider<CurrencyConverterController>((ref) {
  final service = ref.watch(currencyServiceProvider);
  return CurrencyConverterController(service);
});
