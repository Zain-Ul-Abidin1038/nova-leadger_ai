import 'package:hive/hive.dart';

part 'investment.g.dart';

@HiveType(typeId: 21)
class Investment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final InvestmentType type;

  @HiveField(3)
  final String symbol;

  @HiveField(4)
  final String name;

  @HiveField(5)
  final double quantity;

  @HiveField(6)
  final double purchasePrice;

  @HiveField(7)
  final double currentPrice;

  @HiveField(8)
  final DateTime purchaseDate;

  @HiveField(9)
  final DateTime updatedAt;

  @HiveField(10)
  final String? notes;

  Investment({
    required this.id,
    required this.userId,
    required this.type,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.currentPrice,
    required this.purchaseDate,
    required this.updatedAt,
    this.notes,
  });

  double get totalInvested => quantity * purchasePrice;
  double get currentValue => quantity * currentPrice;
  double get profitLoss => currentValue - totalInvested;
  double get profitLossPercentage => (profitLoss / totalInvested) * 100;

  bool get isProfit => profitLoss >= 0;

  Investment copyWith({
    String? id,
    String? userId,
    InvestmentType? type,
    String? symbol,
    String? name,
    double? quantity,
    double? purchasePrice,
    double? currentPrice,
    DateTime? purchaseDate,
    DateTime? updatedAt,
    String? notes,
  }) {
    return Investment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'symbol': symbol,
      'name': name,
      'quantity': quantity,
      'purchasePrice': purchasePrice,
      'currentPrice': currentPrice,
      'purchaseDate': purchaseDate.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: InvestmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => InvestmentType.stock,
      ),
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
    );
  }
}

@HiveType(typeId: 22)
enum InvestmentType {
  @HiveField(0)
  stock,

  @HiveField(1)
  mutualFund,

  @HiveField(2)
  bond,

  @HiveField(3)
  etf,

  @HiveField(4)
  commodity,
}

extension InvestmentTypeExtension on InvestmentType {
  String get displayName {
    switch (this) {
      case InvestmentType.stock:
        return 'Stock';
      case InvestmentType.mutualFund:
        return 'Mutual Fund';
      case InvestmentType.bond:
        return 'Bond';
      case InvestmentType.etf:
        return 'ETF';
      case InvestmentType.commodity:
        return 'Commodity';
    }
  }

  String get icon {
    switch (this) {
      case InvestmentType.stock:
        return '📈';
      case InvestmentType.mutualFund:
        return '💼';
      case InvestmentType.bond:
        return '📊';
      case InvestmentType.etf:
        return '🎯';
      case InvestmentType.commodity:
        return '🥇';
    }
  }
}
