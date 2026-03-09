import 'package:hive/hive.dart';

part 'group_expense.g.dart';

@HiveType(typeId: 32)
class GroupExpense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double totalAmount;

  @HiveField(4)
  final String createdBy;

  @HiveField(5)
  final List<ExpenseParticipant> participants;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final bool isSettled;

  GroupExpense({
    required this.id,
    required this.name,
    required this.description,
    required this.totalAmount,
    required this.createdBy,
    required this.participants,
    required this.createdAt,
    required this.isSettled,
  });

  double get totalPaid => participants.fold(0.0, (sum, p) => sum + (p.paid ? p.shareAmount : 0));
  double get totalOwed => totalAmount - totalPaid;
  bool get isFullyPaid => totalPaid >= totalAmount;

  GroupExpense copyWith({
    String? id,
    String? name,
    String? description,
    double? totalAmount,
    String? createdBy,
    List<ExpenseParticipant>? participants,
    DateTime? createdAt,
    bool? isSettled,
  }) {
    return GroupExpense(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      createdBy: createdBy ?? this.createdBy,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      isSettled: isSettled ?? this.isSettled,
    );
  }
}

@HiveType(typeId: 33)
class ExpenseParticipant extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double shareAmount;

  @HiveField(3)
  final bool paid;

  ExpenseParticipant({
    required this.userId,
    required this.name,
    required this.shareAmount,
    required this.paid,
  });
}
