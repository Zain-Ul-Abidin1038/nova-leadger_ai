import 'package:hive/hive.dart';

part 'shared_goal.g.dart';

@HiveType(typeId: 31)
class SharedGoal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String familyAccountId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double targetAmount;

  @HiveField(5)
  final double currentAmount;

  @HiveField(6)
  final DateTime deadline;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final List<String> contributorIds;

  SharedGoal({
    required this.id,
    required this.familyAccountId,
    required this.name,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.createdAt,
    required this.contributorIds,
  });

  double get progressPercentage => (currentAmount / targetAmount) * 100;
  bool get isCompleted => currentAmount >= targetAmount;
  int get daysRemaining => deadline.difference(DateTime.now()).inDays;

  SharedGoal copyWith({
    String? id,
    String? familyAccountId,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    DateTime? createdAt,
    List<String>? contributorIds,
  }) {
    return SharedGoal(
      id: id ?? this.id,
      familyAccountId: familyAccountId ?? this.familyAccountId,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      contributorIds: contributorIds ?? this.contributorIds,
    );
  }
}
