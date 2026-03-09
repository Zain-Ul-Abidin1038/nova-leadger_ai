import 'package:hive/hive.dart';

part 'business_expense.g.dart';

@HiveType(typeId: 34)
class BusinessExpense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessEntityId;

  @HiveField(2)
  final String department;

  @HiveField(3)
  final String project;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final double amount;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final String submittedBy;

  @HiveField(8)
  final ApprovalStatus status;

  @HiveField(9)
  final DateTime submittedAt;

  @HiveField(10)
  final String? receiptUrl;

  BusinessExpense({
    required this.id,
    required this.businessEntityId,
    required this.department,
    required this.project,
    required this.category,
    required this.amount,
    required this.description,
    required this.submittedBy,
    required this.status,
    required this.submittedAt,
    this.receiptUrl,
  });

  bool get isPending => status == ApprovalStatus.pending;
  bool get isApproved => status == ApprovalStatus.approved;
  bool get isRejected => status == ApprovalStatus.rejected;

  BusinessExpense copyWith({
    String? id,
    String? businessEntityId,
    String? department,
    String? project,
    String? category,
    double? amount,
    String? description,
    String? submittedBy,
    ApprovalStatus? status,
    DateTime? submittedAt,
    String? receiptUrl,
  }) {
    return BusinessExpense(
      id: id ?? this.id,
      businessEntityId: businessEntityId ?? this.businessEntityId,
      department: department ?? this.department,
      project: project ?? this.project,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      submittedBy: submittedBy ?? this.submittedBy,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      receiptUrl: receiptUrl ?? this.receiptUrl,
    );
  }
}

@HiveType(typeId: 35)
enum ApprovalStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  approved,

  @HiveField(2)
  rejected,

  @HiveField(3)
  needsReview,
}
