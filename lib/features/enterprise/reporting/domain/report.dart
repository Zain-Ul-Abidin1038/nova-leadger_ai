// Report domain models

enum ReportType {
  financial,
  expense,
  revenue,
  tax,
  custom,
}

class Report {
  final String id;
  final String name;
  final ReportType type;
  final DateTime generatedAt;
  final DateTime createdAt;
  final Map<String, dynamic> data;
  final DateTime startDate;
  final DateTime endDate;

  Report({
    required this.id,
    required this.name,
    required this.type,
    DateTime? generatedAt,
    DateTime? createdAt,
    required this.data,
    required this.startDate,
    required this.endDate,
  }) : generatedAt = generatedAt ?? DateTime.now(),
       createdAt = createdAt ?? (generatedAt ?? DateTime.now());
}
