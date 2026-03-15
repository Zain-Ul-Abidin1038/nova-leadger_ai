// Shared goals domain model

class SharedGoal {
  final String id;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final List<String> participants;
  final String familyAccountId;

  SharedGoal({
    required this.id,
    required this.name,
    String? description,
    required this.targetAmount,
    required this.currentAmount,
    DateTime? deadline,
    required this.participants,
    this.familyAccountId = '',
    DateTime? createdAt,
  }) : description = description ?? '',
       deadline = deadline ?? DateTime.now().add(const Duration(days: 30));

  double get progress => (currentAmount / targetAmount) * 100;
  double get progressPercentage => progress.clamp(0.0, 100.0);
  bool get isCompleted => currentAmount >= targetAmount;
  int get daysRemaining => deadline.difference(DateTime.now()).inDays;

  SharedGoal copyWith({
    String? id,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    List<String>? participants,
    String? familyAccountId,
  }) {
    return SharedGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      participants: participants ?? this.participants,
      familyAccountId: familyAccountId ?? this.familyAccountId,
    );
  }
}
