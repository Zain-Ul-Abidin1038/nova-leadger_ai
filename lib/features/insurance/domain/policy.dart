import 'package:hive/hive.dart';

part 'policy.g.dart';

@HiveType(typeId: 26)
class InsurancePolicy extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final PolicyType type;

  @HiveField(3)
  final String provider;

  @HiveField(4)
  final String policyNumber;

  @HiveField(5)
  final double premium;

  @HiveField(6)
  final double coverage;

  @HiveField(7)
  final DateTime expiryDate;

  @HiveField(8)
  final DateTime createdAt;

  InsurancePolicy({
    required this.id,
    required this.userId,
    required this.type,
    required this.provider,
    required this.policyNumber,
    required this.premium,
    required this.coverage,
    required this.expiryDate,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isExpiringSoon => expiryDate.difference(DateTime.now()).inDays <= 30;
  double get annualPremium => premium * 12;

  InsurancePolicy copyWith({
    String? id,
    String? userId,
    PolicyType? type,
    String? provider,
    String? policyNumber,
    double? premium,
    double? coverage,
    DateTime? expiryDate,
    DateTime? createdAt,
  }) {
    return InsurancePolicy(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      provider: provider ?? this.provider,
      policyNumber: policyNumber ?? this.policyNumber,
      premium: premium ?? this.premium,
      coverage: coverage ?? this.coverage,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 27)
enum PolicyType {
  @HiveField(0)
  life,

  @HiveField(1)
  health,

  @HiveField(2)
  auto,

  @HiveField(3)
  home,

  @HiveField(4)
  travel,
}
