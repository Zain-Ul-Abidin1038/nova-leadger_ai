// Business expense domain model

enum ApprovalStatus {
  pending,
  approved,
  rejected,
}

class BusinessExpense {
  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final DateTime submittedAt;
  final String employeeId;
  final bool isApproved;
  final ApprovalStatus status;
  final String department;
  final String project;
  final String submittedBy;
  final String businessEntityId;

  BusinessExpense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
    DateTime? submittedAt,
    String? employeeId,
    this.isApproved = false,
    ApprovalStatus? status,
    this.department = '',
    this.project = '',
    this.submittedBy = '',
    this.businessEntityId = '',
  }) : date = date ?? DateTime.now(),
       employeeId = employeeId ?? 'current_user',
       status = status ?? (isApproved ? ApprovalStatus.approved : ApprovalStatus.pending),
       submittedAt = submittedAt ?? (date ?? DateTime.now());

  bool get isPending => status == ApprovalStatus.pending;
  bool get isRejected => status == ApprovalStatus.rejected;

  BusinessExpense copyWith({
    String? id,
    String? description,
    double? amount,
    String? category,
    DateTime? date,
    String? employeeId,
    bool? isApproved,
    ApprovalStatus? status,
    String? department,
    String? project,
    String? submittedBy,
    String? businessEntityId,
  }) {
    return BusinessExpense(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      employeeId: employeeId ?? this.employeeId,
      isApproved: isApproved ?? this.isApproved,
      status: status ?? this.status,
      department: department ?? this.department,
      project: project ?? this.project,
      submittedBy: submittedBy ?? this.submittedBy,
      businessEntityId: businessEntityId ?? this.businessEntityId,
    );
  }
}
