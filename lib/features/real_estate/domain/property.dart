import 'package:hive/hive.dart';

part 'property.g.dart';

@HiveType(typeId: 24)
class Property extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final PropertyType type;

  @HiveField(4)
  final double purchasePrice;

  @HiveField(5)
  final double currentValue;

  @HiveField(6)
  final double? mortgageBalance;

  @HiveField(7)
  final double? rentalIncome;

  @HiveField(8)
  final DateTime purchaseDate;

  @HiveField(9)
  final DateTime updatedAt;

  Property({
    required this.id,
    required this.userId,
    required this.address,
    required this.type,
    required this.purchasePrice,
    required this.currentValue,
    this.mortgageBalance,
    this.rentalIncome,
    required this.purchaseDate,
    required this.updatedAt,
  });

  double get equity => currentValue - (mortgageBalance ?? 0);
  double get appreciation => currentValue - purchasePrice;
  double get appreciationPercentage => (appreciation / purchasePrice) * 100;
  double get annualRentalIncome => (rentalIncome ?? 0) * 12;

  Property copyWith({
    String? id,
    String? userId,
    String? address,
    PropertyType? type,
    double? purchasePrice,
    double? currentValue,
    double? mortgageBalance,
    double? rentalIncome,
    DateTime? purchaseDate,
    DateTime? updatedAt,
  }) {
    return Property(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      type: type ?? this.type,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentValue: currentValue ?? this.currentValue,
      mortgageBalance: mortgageBalance ?? this.mortgageBalance,
      rentalIncome: rentalIncome ?? this.rentalIncome,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@HiveType(typeId: 25)
enum PropertyType {
  @HiveField(0)
  residential,

  @HiveField(1)
  commercial,

  @HiveField(2)
  land,

  @HiveField(3)
  rental,
}
