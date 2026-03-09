import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/transaction_model.dart';

final financeServiceProvider = Provider((ref) => FinanceService());

class FinanceService {
  static const String _boxName = 'financial_transactions';
  final _uuid = const Uuid();

  Future<Box<FinancialTransaction>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<FinancialTransaction>(_boxName);
    }
    return Hive.box<FinancialTransaction>(_boxName);
  }

  /// Add expense
  Future<FinancialTransaction> addExpense({
    required double amount,
    required String category,
    String? description,
    String? receiptId,
  }) async {
    final transaction = FinancialTransaction(
      id: _uuid.v4(),
      amount: amount,
      type: 'expense',
      category: category,
      description: description,
      date: DateTime.now(),
      receiptId: receiptId,
    );

    final box = await _getBox();
    await box.put(transaction.id, transaction);
    print('[Finance] ✓ Expense added: ₹$amount - $category');
    return transaction;
  }

  /// Add income
  Future<FinancialTransaction> addIncome({
    required double amount,
    required String category,
    String? description,
  }) async {
    final transaction = FinancialTransaction(
      id: _uuid.v4(),
      amount: amount,
      type: 'income',
      category: category,
      description: description,
      date: DateTime.now(),
    );

    final box = await _getBox();
    await box.put(transaction.id, transaction);
    print('[Finance] ✓ Income added: ₹$amount - $category');
    return transaction;
  }

  /// Add loan given (money lent to someone)
  Future<FinancialTransaction> addLoanGiven({
    required double amount,
    required String personName,
    String? description,
  }) async {
    final transaction = FinancialTransaction(
      id: _uuid.v4(),
      amount: amount,
      type: 'loan_given',
      category: 'Loan',
      personName: personName,
      description: description,
      date: DateTime.now(),
      isPaid: false,
    );

    final box = await _getBox();
    await box.put(transaction.id, transaction);
    print('[Finance] ✓ Loan given: ₹$amount to $personName');
    return transaction;
  }

  /// Add loan received (money borrowed from someone)
  Future<FinancialTransaction> addLoanReceived({
    required double amount,
    required String personName,
    String? description,
  }) async {
    final transaction = FinancialTransaction(
      id: _uuid.v4(),
      amount: amount,
      type: 'loan_received',
      category: 'Loan',
      personName: personName,
      description: description,
      date: DateTime.now(),
      isPaid: false,
    );

    final box = await _getBox();
    await box.put(transaction.id, transaction);
    print('[Finance] ✓ Loan received: ₹$amount from $personName');
    return transaction;
  }

  /// Mark loan as paid
  Future<void> markLoanAsPaid(String transactionId) async {
    final box = await _getBox();
    final transaction = box.get(transactionId);
    if (transaction != null) {
      final updated = FinancialTransaction(
        id: transaction.id,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        description: transaction.description,
        personName: transaction.personName,
        date: transaction.date,
        isPaid: true,
        receiptId: transaction.receiptId,
      );
      await box.put(transactionId, updated);
      print('[Finance] ✓ Loan marked as paid: ${transaction.personName}');
    }
  }

  /// Get all transactions
  Future<List<FinancialTransaction>> getAllTransactions() async {
    final box = await _getBox();
    return box.values.toList();
  }

  /// Get transactions by type
  Future<List<FinancialTransaction>> getTransactionsByType(String type) async {
    final box = await _getBox();
    return box.values.where((t) => t.type == type).toList();
  }

  /// Get unpaid loans
  Future<List<FinancialTransaction>> getUnpaidLoans() async {
    final box = await _getBox();
    return box.values
        .where((t) =>
            (t.type == 'loan_given' || t.type == 'loan_received') &&
            !t.isPaid)
        .toList();
  }

  /// Calculate total expenses
  Future<double> getTotalExpenses() async {
    final box = await _getBox();
    return box.values
        .where((t) => t.type == 'expense')
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculate total income
  Future<double> getTotalIncome() async {
    final box = await _getBox();
    return box.values
        .where((t) => t.type == 'income')
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculate money owed to you (loans given not paid)
  Future<double> getMoneyOwedToYou() async {
    final box = await _getBox();
    return box.values
        .where((t) => t.type == 'loan_given' && !t.isPaid)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculate money you owe (loans received not paid)
  Future<double> getMoneyYouOwe() async {
    final box = await _getBox();
    return box.values
        .where((t) => t.type == 'loan_received' && !t.isPaid)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  /// Get financial summary
  Future<Map<String, dynamic>> getFinancialSummary() async {
    final totalExpenses = await getTotalExpenses();
    final totalIncome = await getTotalIncome();
    final moneyOwedToYou = await getMoneyOwedToYou();
    final moneyYouOwe = await getMoneyYouOwe();
    final balance = totalIncome - totalExpenses;

    return {
      'totalExpenses': totalExpenses,
      'totalIncome': totalIncome,
      'balance': balance,
      'moneyOwedToYou': moneyOwedToYou,
      'moneyYouOwe': moneyYouOwe,
      'netWorth': balance + moneyOwedToYou - moneyYouOwe,
    };
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    final box = await _getBox();
    await box.delete(id);
    print('[Finance] ✓ Transaction deleted: $id');
  }
}
