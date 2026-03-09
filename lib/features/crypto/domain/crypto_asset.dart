import 'package:hive/hive.dart';

part 'crypto_asset.g.dart';

@HiveType(typeId: 23)
class CryptoAsset extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String symbol;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final double quantity;

  @HiveField(5)
  final double purchasePrice;

  @HiveField(6)
  final double currentPrice;

  @HiveField(7)
  final String? walletAddress;

  @HiveField(8)
  final DateTime purchaseDate;

  @HiveField(9)
  final DateTime updatedAt;

  CryptoAsset({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.currentPrice,
    this.walletAddress,
    required this.purchaseDate,
    required this.updatedAt,
  });

  double get totalInvested => quantity * purchasePrice;
  double get currentValue => quantity * currentPrice;
  double get profitLoss => currentValue - totalInvested;
  double get profitLossPercentage => (profitLoss / totalInvested) * 100;
  bool get isProfit => profitLoss >= 0;

  CryptoAsset copyWith({
    String? id,
    String? userId,
    String? symbol,
    String? name,
    double? quantity,
    double? purchasePrice,
    double? currentPrice,
    String? walletAddress,
    DateTime? purchaseDate,
    DateTime? updatedAt,
  }) {
    return CryptoAsset(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      walletAddress: walletAddress ?? this.walletAddress,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
