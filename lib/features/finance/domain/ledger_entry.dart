import 'package:hive_flutter/hive_flutter.dart';

part 'ledger_entry.g.dart';

@HiveType(typeId: 12)
enum LedgerType {
  @HiveField(0)
  receivable, // Money owed to you
  
  @HiveField(1)
  payable, // Money you owe
}

@HiveType(typeId: 13)
class LedgerEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String personOrCompany; // Who owes or is owed

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? dueDate;

  @HiveField(6)
  final LedgerType type;

  @HiveField(7)
  final bool isPaid;

  @HiveField(8)
  final DateTime? paidAt;

  @HiveField(9)
  final String? notes;

  LedgerEntry({
    required this.id,
    required this.amount,
    required this.personOrCompany,
    required this.description,
    required this.createdAt,
    this.dueDate,
    required this.type,
    this.isPaid = false,
    this.paidAt,
    this.notes,
  });

  factory LedgerEntry.create({
    required double amount,
    required String personOrCompany,
    required String description,
    required LedgerType type,
    DateTime? dueDate,
    String? notes,
  }) {
    return LedgerEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      personOrCompany: personOrCompany,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      type: type,
      notes: notes,
    );
  }

  LedgerEntry copyWith({
    bool? isPaid,
    DateTime? paidAt,
  }) {
    return LedgerEntry(
      id: id,
      amount: amount,
      personOrCompany: personOrCompany,
      description: description,
      createdAt: createdAt,
      dueDate: dueDate,
      type: type,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      notes: notes,
    );
  }
}
