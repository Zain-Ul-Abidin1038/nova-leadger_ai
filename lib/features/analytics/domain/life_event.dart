import 'package:hive_flutter/hive_flutter.dart';

part 'life_event.g.dart';

/// Life Event Model
/// Represents detected major financial transitions
@HiveType(typeId: 7)
class LifeEvent {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime detectedAt;

  @HiveField(4)
  final double confidence; // 0-1

  @HiveField(5)
  final Map<String, dynamic> metadata;

  @HiveField(6)
  final bool acknowledged;

  LifeEvent({
    required this.id,
    required this.type,
    required this.description,
    required this.detectedAt,
    required this.confidence,
    this.metadata = const {},
    this.acknowledged = false,
  });

  LifeEvent copyWith({
    String? id,
    String? type,
    String? description,
    DateTime? detectedAt,
    double? confidence,
    Map<String, dynamic>? metadata,
    bool? acknowledged,
  }) {
    return LifeEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      detectedAt: detectedAt ?? this.detectedAt,
      confidence: confidence ?? this.confidence,
      metadata: metadata ?? this.metadata,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }
}

/// Life Event Types
class LifeEventType {
  static const String incomeIncrease = 'income_increase';
  static const String incomeDecrease = 'income_decrease';
  static const String relocationPattern = 'relocation_pattern';
  static const String majorPurchaseTrend = 'major_purchase_trend';
  static const String financialStressRisk = 'financial_stress_risk';
  static const String savingsMilestone = 'savings_milestone';
  static const String debtFree = 'debt_free';
  static const String emergencyFundReached = 'emergency_fund_reached';
  static const String spendingSpike = 'spending_spike';
  static const String incomeStabilization = 'income_stabilization';
  static const String categoryShift = 'category_shift';
  static const String financialSecurityMilestone = 'financial_security_milestone';
}
