// Property domain models

enum PropertyType {
  residential,
  commercial,
  land,
  rental,
}

class Property {
  final String id;
  final String name;
  final PropertyType type;
  final double purchasePrice;
  final double currentValue;
  final String address;
  final DateTime purchaseDate;
  final double? equity;
  final double? appreciationPercentage;
  final double? rentalIncome;

  Property({
    required this.id,
    required this.name,
    required this.type,
    required this.purchasePrice,
    required this.currentValue,
    required this.address,
    required this.purchaseDate,
    this.equity,
    this.appreciationPercentage,
    this.rentalIncome,
  });

  double? get annualRentalIncome => rentalIncome != null ? rentalIncome! * 12 : null;
}
