import 'package:hive_flutter/hive_flutter.dart';

part 'financial_goal.g.dart';

/// Financial Goal Model
/// Represents user's financial objectives
@HiveType(typeId: 8)
class FinancialGoal {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final double targetAmount;

  @HiveField(4)
  final double currentAmount;

  @HiveField(5)
  final DateTime targetDate;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final bool completed;

  @HiveField(8)
  final int priority; // 1-10

  FinancialGoal({
    required this.id,
    required this.type,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.createdAt,
    this.completed = false,
    this.priority = 5,
  });

  double get progress => currentAmount / targetAmount;
  
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
  
  double get requiredMonthlyContribution {
    final monthsRemaining = daysRemaining / 30;
    if (monthsRemaining <= 0) return 0;
    return (targetAmount - currentAmount) / monthsRemaining;
  }

  FinancialGoal copyWith({
    String? id,
    String? type,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    DateTime? createdAt,
    bool? completed,
    int? priority,
  }) {
    return FinancialGoal(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
    );
  }
}

/// Goal Types
class GoalType {
  static const String emergencyFund = 'emergency_fund';
  static const String debtPayoff = 'debt_payoff';
  static const String savingsTarget = 'savings_target';
  static const String netWorthMilestone = 'net_worth_milestone';
  static const String retirement = 'retirement';
  static const String majorPurchase = 'major_purchase';
  static const String investment = 'investment';
}

/// Goal Action
class GoalAction {
  final String goalId;
  final String recommendation;
  final double suggestedContribution;
  final int priority;

  GoalAction({
    required this.goalId,
    required this.recommendation,
    required this.suggestedContribution,
    required this.priority,
  });
}
