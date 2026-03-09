import 'financial_snapshot.dart';
import 'user_financial_profile.dart';

/// Financial Context
/// Complete context for agent analysis
class FinancialContext {
  final FinancialSnapshot snapshot;
  final UserFinancialProfile profile;
  final EconomicDigitalTwin twin;
  final Map<String, dynamic> metadata;

  FinancialContext({
    required this.snapshot,
    required this.profile,
    required this.twin,
    this.metadata = const {},
  });
}

/// Economic Digital Twin
/// Live simulation of user's financial life
class EconomicDigitalTwin {
  double balance;
  double monthlyIncome;
  double monthlyExpenses;
  double savingsRate;
  double riskTolerance;
  double investmentReturnExpectation;
  DateTime lastUpdated;

  EconomicDigitalTwin({
    required this.balance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.savingsRate,
    required this.riskTolerance,
    required this.investmentReturnExpectation,
    required this.lastUpdated,
  });

  factory EconomicDigitalTwin.fromSnapshot(FinancialSnapshot snapshot) {
    final savingsRate = snapshot.monthlyIncome > 0
        ? (snapshot.monthlyIncome - snapshot.monthlyExpenses) /
            snapshot.monthlyIncome
        : 0.0;

    return EconomicDigitalTwin(
      balance: snapshot.balance,
      monthlyIncome: snapshot.monthlyIncome,
      monthlyExpenses: snapshot.monthlyExpenses,
      savingsRate: savingsRate,
      riskTolerance: 0.5, // Default, will be computed
      investmentReturnExpectation: 0.08, // 8% annual default
      lastUpdated: DateTime.now(),
    );
  }

  /// Project net worth
  double projectNetWorth(int months) {
    double wealth = balance;

    for (int i = 0; i < months; i++) {
      wealth += monthlyIncome - monthlyExpenses;
      wealth *= (1 + investmentReturnExpectation / 12);
    }

    return wealth;
  }

  /// Update from snapshot
  void updateFromSnapshot(FinancialSnapshot snapshot) {
    balance = snapshot.balance;
    monthlyIncome = snapshot.monthlyIncome;
    monthlyExpenses = snapshot.monthlyExpenses;
    savingsRate = monthlyIncome > 0
        ? (monthlyIncome - monthlyExpenses) / monthlyIncome
        : 0.0;
    lastUpdated = DateTime.now();
  }
}

/// User Behavior Model
class UserBehavior {
  final bool frequentWithdrawals;
  final bool increasingSavings;
  final bool consistentIncome;
  final bool lowVolatility;

  UserBehavior({
    required this.frequentWithdrawals,
    required this.increasingSavings,
    required this.consistentIncome,
    required this.lowVolatility,
  });
}
