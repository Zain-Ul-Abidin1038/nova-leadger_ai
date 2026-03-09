import 'package:hive_flutter/hive_flutter.dart';

part 'expense_entry.g.dart';

@HiveType(typeId: 11)
class ExpenseEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String vendor; // Where you spent

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String category; // food, transport, entertainment, etc.

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final String? location;

  @HiveField(8)
  final String? receiptImagePath;

  ExpenseEntry({
    required this.id,
    required this.amount,
    required this.vendor,
    required this.description,
    required this.timestamp,
    required this.category,
    this.notes,
    this.location,
    this.receiptImagePath,
  });

  factory ExpenseEntry.create({
    required double amount,
    required String vendor,
    required String description,
    required String category,
    String? notes,
    String? location,
    String? receiptImagePath,
  }) {
    return ExpenseEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      vendor: vendor,
      description: description,
      timestamp: DateTime.now(),
      category: category,
      notes: notes,
      location: location,
      receiptImagePath: receiptImagePath,
    );
  }
}
