// Group expense domain model

class GroupExpenseParticipant {
  final String userId;
  final String name;
  final double shareAmount;
  final bool paid;

  GroupExpenseParticipant({
    required this.userId,
    required this.name,
    required this.shareAmount,
    this.paid = false,
  });
}

class GroupExpense {
  final String id;
  final String name;
  final String description;
  final double amount;
  final double totalAmount;
  final String paidBy;
  final String createdBy;
  final List<GroupExpenseParticipant> participants;
  final DateTime date;
  final DateTime submittedAt;

  GroupExpense({
    required this.id,
    String? name,
    required this.description,
    required this.amount,
    double? totalAmount,
    required this.paidBy,
    String? createdBy,
    required this.participants,
    DateTime? date,
    DateTime? submittedAt,
    DateTime? createdAt,
  }) : name = name ?? description,
       totalAmount = totalAmount ?? amount,
       createdBy = createdBy ?? paidBy,
       date = date ?? DateTime.now(),
       submittedAt = submittedAt ?? (createdAt ?? (date ?? DateTime.now()));

  double get perPersonAmount => amount / participants.length;
  
  bool get isFullyPaid => participants.every((p) => p.paid);
  bool get isSettled => isFullyPaid;

  GroupExpense copyWith({
    String? id,
    String? name,
    String? description,
    double? amount,
    double? totalAmount,
    String? paidBy,
    String? createdBy,
    List<GroupExpenseParticipant>? participants,
    DateTime? date,
    DateTime? submittedAt,
  }) {
    return GroupExpense(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidBy: paidBy ?? this.paidBy,
      createdBy: createdBy ?? this.createdBy,
      participants: participants ?? this.participants,
      date: date ?? this.date,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}
