import 'package:hive/hive.dart';

part 'report.g.dart';

@HiveType(typeId: 39)
class Report extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessEntityId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final ReportType type;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime endDate;

  @HiveField(6)
  final String createdBy;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final Map<String, dynamic> data;

  Report({
    required this.id,
    required this.businessEntityId,
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    required this.createdAt,
    required this.data,
  });

  Report copyWith({
    String? id,
    String? businessEntityId,
    String? name,
    ReportType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? createdBy,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return Report(
      id: id ?? this.id,
      businessEntityId: businessEntityId ?? this.businessEntityId,
      name: name ?? this.name,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
}

@HiveType(typeId: 40)
enum ReportType {
  @HiveField(0)
  expense,

  @HiveField(1)
  income,

  @HiveField(2)
  profitLoss,

  @HiveField(3)
  cashFlow,

  @HiveField(4)
  tax,

  @HiveField(5)
  custom,
}
