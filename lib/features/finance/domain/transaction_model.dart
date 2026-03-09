import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class FinancialTransaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String type; // 'expense', 'income', 'loan_given', 'loan_received'

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String? personName; // For loans

  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final bool isPaid; // For tracking loan repayment

  @HiveField(8)
  final String? receiptId; // Link to receipt if scanned

  FinancialTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    this.description,
    this.personName,
    required this.date,
    this.isPaid = false,
    this.receiptId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'type': type,
        'category': category,
        'description': description,
        'personName': personName,
        'date': date.toIso8601String(),
        'isPaid': isPaid,
        'receiptId': receiptId,
      };

  factory FinancialTransaction.fromJson(Map<String, dynamic> json) =>
      FinancialTransaction(
        id: json['id'],
        amount: json['amount'],
        type: json['type'],
        category: json['category'],
        description: json['description'],
        personName: json['personName'],
        date: DateTime.parse(json['date']),
        isPaid: json['isPaid'] ?? false,
        receiptId: json['receiptId'],
      );
}
