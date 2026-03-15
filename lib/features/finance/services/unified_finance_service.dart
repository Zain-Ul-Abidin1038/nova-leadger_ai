import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/income_entry.dart';
import '../domain/expense_entry.dart';
import '../domain/ledger_entry.dart';

// Singleton instance to ensure all parts of the app use the same service
final unifiedFinanceServiceProvider = Provider((ref) {
  final service = UnifiedFinanceService._instance;
  // Initialize on first access
  service.initialize();
  return service;
});

// Stream providers for reactive UI updates
final incomeEntriesProvider = StreamProvider<List<IncomeEntry>>((ref) {
  final service = ref.watch(unifiedFinanceServiceProvider);
  return service.incomeStream;
});

final expenseEntriesProvider = StreamProvider<List<ExpenseEntry>>((ref) {
  final service = ref.watch(unifiedFinanceServiceProvider);
  return service.expenseStream;
});

final ledgerEntriesProvider = StreamProvider<List<LedgerEntry>>((ref) {
  final service = ref.watch(unifiedFinanceServiceProvider);
  return service.ledgerStream;
});

class UnifiedFinanceService {
  // Singleton pattern
  static final UnifiedFinanceService _instance = UnifiedFinanceService._internal();
  factory UnifiedFinanceService() => _instance;
  UnifiedFinanceService._internal();
  
  static const String _incomeBoxName = 'income_entries';
  static const String _expenseBoxName = 'expense_entries';
  static const String _ledgerBoxName = 'ledger_entries';

  Box<IncomeEntry>? _incomeBox;
  Box<ExpenseEntry>? _expenseBox;
  Box<LedgerEntry>? _ledgerBox;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    safePrint('[UnifiedFinanceService] Initializing...');
    
    // Register adapters
    if (!Hive.isAdapterRegistered(10)) {
      // Hive.registerAdapter(IncomeEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      // Hive.registerAdapter(ExpenseEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      // Hive.registerAdapter(LedgerTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      // Hive.registerAdapter(LedgerEntryAdapter());
    }

    // Open boxes
    _incomeBox = await Hive.openBox<IncomeEntry>(_incomeBoxName);
    _expenseBox = await Hive.openBox<ExpenseEntry>(_expenseBoxName);
    _ledgerBox = await Hive.openBox<LedgerEntry>(_ledgerBoxName);

    _initialized = true;
    safePrint('[UnifiedFinanceService] Initialized successfully');
  }

  // ==================== STREAMS FOR REACTIVE UI ====================
  
  Stream<List<IncomeEntry>> get incomeStream async* {
    if (_incomeBox == null) await initialize();
    yield getAllIncome();
    await for (final _ in _incomeBox!.watch()) {
      yield getAllIncome();
    }
  }

  Stream<List<ExpenseEntry>> get expenseStream async* {
    if (_expenseBox == null) await initialize();
    yield getAllExpenses();
    await for (final _ in _expenseBox!.watch()) {
      yield getAllExpenses();
    }
  }

  Stream<List<LedgerEntry>> get ledgerStream async* {
    if (_ledgerBox == null) await initialize();
    yield getAllLedgerEntries();
    await for (final _ in _ledgerBox!.watch()) {
      yield getAllLedgerEntries();
    }
  }

  // ==================== INCOME ====================
  
  Future<IncomeEntry> addIncome(IncomeEntry entry) async {
    await _incomeBox?.add(entry);
    safePrint('[UnifiedFinanceService] Added income: ${entry.amount} from ${entry.source}');
    return entry;
  }

  List<IncomeEntry> getAllIncome() {
    return _incomeBox?.values.toList() ?? [];
  }

  double getTotalIncome() {
    return getAllIncome().fold(0.0, (sum, entry) => sum + entry.amount);
  }

  // ==================== EXPENSE ====================
  
  Future<ExpenseEntry> addExpense(ExpenseEntry entry) async {
    await _expenseBox?.add(entry);
    safePrint('[UnifiedFinanceService] Added expense: ${entry.amount} at ${entry.vendor}');
    return entry;
  }

  /// Add expense from map (used by NovaNavigator)
  Future<ExpenseEntry> addExpenseFromMap(Map<String, dynamic> data) async {
    final entry = ExpenseEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String? ?? 'other',
      vendor: data['vendor'] as String? ?? 'Unknown',
      description: data['description'] as String? ?? '',
      timestamp: data['timestamp'] != null 
          ? DateTime.parse(data['timestamp'] as String)
          : DateTime.now(),
      notes: data['notes'] as String?,
      location: data['location'] as String?,
      receiptImagePath: data['receiptImagePath'] as String?,
    );
    return await addExpense(entry);
  }

  List<ExpenseEntry> getAllExpenses() {
    return _expenseBox?.values.toList() ?? [];
  }

  double getTotalExpenses() {
    return getAllExpenses().fold(0.0, (sum, entry) => sum + entry.amount);
  }

  Map<String, double> getExpensesByCategory() {
    final expenses = getAllExpenses();
    final Map<String, double> categoryTotals = {};
    
    for (final expense in expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0.0) + expense.amount;
    }
    
    return categoryTotals;
  }

  // ==================== LEDGER ====================
  
  Future<LedgerEntry> addLedgerEntry(LedgerEntry entry) async {
    await _ledgerBox?.add(entry);
    safePrint('[UnifiedFinanceService] Added ledger: ${entry.type.name} ${entry.amount} - ${entry.personOrCompany}');
    return entry;
  }

  List<LedgerEntry> getAllLedgerEntries() {
    return _ledgerBox?.values.toList() ?? [];
  }

  List<LedgerEntry> getReceivables() {
    return getAllLedgerEntries()
        .where((e) => e.type == LedgerType.receivable && !e.isPaid)
        .toList();
  }

  List<LedgerEntry> getPayables() {
    return getAllLedgerEntries()
        .where((e) => e.type == LedgerType.payable && !e.isPaid)
        .toList();
  }

  double getTotalReceivables() {
    return getReceivables().fold(0.0, (sum, entry) => sum + entry.amount);
  }

  double getTotalPayables() {
    return getPayables().fold(0.0, (sum, entry) => sum + entry.amount);
  }

  Map<String, List<LedgerEntry>> getLedgerByPerson() {
    final entries = getAllLedgerEntries();
    final Map<String, List<LedgerEntry>> byPerson = {};
    
    for (final entry in entries) {
      if (!byPerson.containsKey(entry.personOrCompany)) {
        byPerson[entry.personOrCompany] = [];
      }
      byPerson[entry.personOrCompany]!.add(entry);
    }
    
    return byPerson;
  }

  Future<void> markLedgerAsPaid(LedgerEntry entry) async {
    final updated = entry.copyWith(
      isPaid: true,
      paidAt: DateTime.now(),
    );
    await entry.save();
    safePrint('[UnifiedFinanceService] Marked ledger as paid: ${entry.id}');
  }

  // ==================== SUMMARY ====================
  
  Map<String, dynamic> getFinancialSummary() {
    final totalIncome = getTotalIncome();
    final totalExpenses = getTotalExpenses();
    final totalReceivables = getTotalReceivables();
    final totalPayables = getTotalPayables();
    
    final balance = totalIncome - totalExpenses;
    final netWorth = balance + totalReceivables - totalPayables;

    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'balance': balance,
      'totalReceivables': totalReceivables,
      'totalPayables': totalPayables,
      'netWorth': netWorth,
      'incomeCount': getAllIncome().length,
      'expenseCount': getAllExpenses().length,
      'ledgerCount': getAllLedgerEntries().length,
    };
  }

  // ==================== CLEANUP ====================
  
  Future<void> clearAllData() async {
    await _incomeBox?.clear();
    await _expenseBox?.clear();
    await _ledgerBox?.clear();
    safePrint('[UnifiedFinanceService] Cleared all data');
  }
}
