import 'package:hive_flutter/hive_flutter.dart';

part 'income_entry.g.dart';

@HiveType(typeId: 10)
class IncomeEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String source; // Who paid you

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String? category; // salary, freelance, gift, etc.

  @HiveField(6)
  final String? notes;

  IncomeEntry({
    required this.id,
    required this.amount,
    required this.source,
    required this.description,
    required this.timestamp,
    this.category,
    this.notes,
  });

  factory IncomeEntry.create({
    required double amount,
    required String source,
    required String description,
    String? category,
    String? notes,
  }) {
    return IncomeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      source: source,
      description: description,
      timestamp: DateTime.now(),
      category: category ?? 'other',
      notes: notes,
    );
  }
}
