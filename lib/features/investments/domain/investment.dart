// Investment domain model

enum InvestmentType {
  stocks,
  bonds,
  mutualFunds,
  realEstate,
  crypto,
  other,
}

class Investment {
  final String id;
  final String name;
  final String type;
  final double amount;
  final double currentValue;
  final DateTime purchaseDate;
  final String symbol;
  final double currentPrice;
  final double totalInvested;
  final double profitLossPercentage;
  final String userId;

  Investment({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.currentValue,
    required this.purchaseDate,
    required this.symbol,
    required this.currentPrice,
    required this.totalInvested,
    required this.profitLossPercentage,
    String? userId,
    double? quantity,
    DateTime? updatedAt,
  }) : userId = userId ?? 'current_user';

  double get returnPercentage => ((currentValue - amount) / amount) * 100;
  
  bool get isProfit => profitLossPercentage >= 0;

  Investment copyWith({
    String? id,
    String? name,
    String? type,
    double? amount,
    double? currentValue,
    DateTime? purchaseDate,
    String? symbol,
    double? currentPrice,
    double? totalInvested,
    double? profitLossPercentage,
  }) {
    return Investment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currentValue: currentValue ?? this.currentValue,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      symbol: symbol ?? this.symbol,
      currentPrice: currentPrice ?? this.currentPrice,
      totalInvested: totalInvested ?? this.totalInvested,
      profitLossPercentage: profitLossPercentage ?? this.profitLossPercentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
      'currentValue': currentValue,
      'purchaseDate': purchaseDate.toIso8601String(),
      'symbol': symbol,
      'currentPrice': currentPrice,
      'totalInvested': totalInvested,
      'profitLossPercentage': profitLossPercentage,
    };
  }

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currentValue: (json['currentValue'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      symbol: json['symbol'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      totalInvested: (json['totalInvested'] as num).toDouble(),
      profitLossPercentage: (json['profitLossPercentage'] as num).toDouble(),
    );
  }
}
