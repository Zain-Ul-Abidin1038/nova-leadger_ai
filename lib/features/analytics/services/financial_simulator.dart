import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

final financialSimulatorProvider = Provider((ref) => FinancialSimulator());

/// Simulation Input
class SimulationInput {
  final double startBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double monthlyReturnRate; // e.g., 0.01 for 1% monthly
  final int months;
  final String scenario;

  SimulationInput({
    required this.startBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.monthlyReturnRate,
    required this.months,
    this.scenario = 'default',
  });

  double get monthlySavings => monthlyIncome - monthlyExpenses;
  double get savingsRate => monthlyIncome > 0 ? monthlySavings / monthlyIncome : 0;
}

/// Simulation Result
class SimulationResult {
  final List<double> balanceTimeline;
  final List<double> savingsTimeline;
  final List<double> investmentGainsTimeline;
  final SimulationInput input;
  final DateTime generatedAt;

  SimulationResult({
    required this.balanceTimeline,
    required this.savingsTimeline,
    required this.investmentGainsTimeline,
    required this.input,
    required this.generatedAt,
  });

  double get finalBalance => balanceTimeline.last;
  double get totalSavings => savingsTimeline.last;
  double get totalInvestmentGains => investmentGainsTimeline.last;
  double get totalGrowth => finalBalance - input.startBalance;
  double get growthPercentage => 
      ((finalBalance - input.startBalance) / input.startBalance) * 100;

  /// Get balance at specific month
  double getBalanceAtMonth(int month) {
    if (month < 1 || month > balanceTimeline.length) return 0;
    return balanceTimeline[month - 1];
  }

  /// Check if goal is achievable
  bool canAchieveGoal(double targetAmount) {
    return finalBalance >= targetAmount;
  }

  /// Get month when target is reached
  int? getMonthWhenTargetReached(double targetAmount) {
    for (int i = 0; i < balanceTimeline.length; i++) {
      if (balanceTimeline[i] >= targetAmount) {
        return i + 1;
      }
    }
    return null;
  }
}

/// Financial Simulator
/// Test "what if" scenarios safely without affecting real data
class FinancialSimulator {
  /// Run simulation
  SimulationResult run(SimulationInput input) {
    safePrint('[Simulator] Running ${input.scenario} scenario for ${input.months} months');
    safePrint('[Simulator] Start: ₹${input.startBalance}, Income: ₹${input.monthlyIncome}, Expenses: ₹${input.monthlyExpenses}');

    double balance = input.startBalance;
    final balanceTimeline = <double>[];
    final savingsTimeline = <double>[];
    final investmentGainsTimeline = <double>[];
    
    double totalSavings = 0;
    double totalInvestmentGains = 0;

    for (int month = 1; month <= input.months; month++) {
      // Add monthly income
      balance += input.monthlyIncome;

      // Subtract monthly expenses
      balance -= input.monthlyExpenses;

      // Track savings
      final monthlySavings = input.monthlyIncome - input.monthlyExpenses;
      totalSavings += monthlySavings;

      // Apply investment returns
      final monthlyGains = balance * input.monthlyReturnRate;
      balance += monthlyGains;
      totalInvestmentGains += monthlyGains;

      // Record timeline
      balanceTimeline.add(balance);
      savingsTimeline.add(totalSavings);
      investmentGainsTimeline.add(totalInvestmentGains);
    }

    safePrint('[Simulator] Final balance: ₹${balance.toStringAsFixed(0)}');
    safePrint('[Simulator] Total growth: ₹${(balance - input.startBalance).toStringAsFixed(0)}');

    return SimulationResult(
      balanceTimeline: balanceTimeline,
      savingsTimeline: savingsTimeline,
      investmentGainsTimeline: investmentGainsTimeline,
      input: input,
      generatedAt: DateTime.now(),
    );
  }

  /// Test lifestyle change
  SimulationResult testLifestyleChange({
    required double currentBalance,
    required double currentIncome,
    required double currentExpenses,
    required double newExpenses,
    int months = 12,
  }) {
    safePrint('[Simulator] Testing lifestyle change: ₹$currentExpenses → ₹$newExpenses');

    return run(SimulationInput(
      startBalance: currentBalance,
      monthlyIncome: currentIncome,
      monthlyExpenses: newExpenses,
      monthlyReturnRate: 0.005, // 0.5% monthly = ~6% annual
      months: months,
      scenario: 'lifestyle_change',
    ));
  }

  /// Test income change
  SimulationResult testIncomeChange({
    required double currentBalance,
    required double currentIncome,
    required double newIncome,
    required double currentExpenses,
    int months = 12,
  }) {
    safePrint('[Simulator] Testing income change: ₹$currentIncome → ₹$newIncome');

    return run(SimulationInput(
      startBalance: currentBalance,
      monthlyIncome: newIncome,
      monthlyExpenses: currentExpenses,
      monthlyReturnRate: 0.005,
      months: months,
      scenario: 'income_change',
    ));
  }

  /// Test savings rate change
  SimulationResult testSavingsRateChange({
    required double currentBalance,
    required double monthlyIncome,
    required double currentSavingsRate,
    required double newSavingsRate,
    int months = 12,
  }) {
    final newExpenses = monthlyIncome * (1 - newSavingsRate);
    
    safePrint('[Simulator] Testing savings rate: ${(currentSavingsRate * 100).toStringAsFixed(0)}% → ${(newSavingsRate * 100).toStringAsFixed(0)}%');

    return run(SimulationInput(
      startBalance: currentBalance,
      monthlyIncome: monthlyIncome,
      monthlyExpenses: newExpenses,
      monthlyReturnRate: 0.005,
      months: months,
      scenario: 'savings_rate_change',
    ));
  }

  /// Test investment return scenarios
  Map<String, SimulationResult> testInvestmentScenarios({
    required double currentBalance,
    required double monthlyIncome,
    required double monthlyExpenses,
    int months = 60, // 5 years
  }) {
    return {
      'conservative': run(SimulationInput(
        startBalance: currentBalance,
        monthlyIncome: monthlyIncome,
        monthlyExpenses: monthlyExpenses,
        monthlyReturnRate: 0.004, // ~5% annual
        months: months,
        scenario: 'conservative',
      )),
      'moderate': run(SimulationInput(
        startBalance: currentBalance,
        monthlyIncome: monthlyIncome,
        monthlyExpenses: monthlyExpenses,
        monthlyReturnRate: 0.008, // ~10% annual
        months: months,
        scenario: 'moderate',
      )),
      'aggressive': run(SimulationInput(
        startBalance: currentBalance,
        monthlyIncome: monthlyIncome,
        monthlyExpenses: monthlyExpenses,
        monthlyReturnRate: 0.012, // ~15% annual
        months: months,
        scenario: 'aggressive',
      )),
    };
  }

  /// Compare two scenarios
  Map<String, dynamic> compareScenarios(
    SimulationResult scenario1,
    SimulationResult scenario2,
  ) {
    final balanceDiff = scenario2.finalBalance - scenario1.finalBalance;
    final growthDiff = scenario2.totalGrowth - scenario1.totalGrowth;

    return {
      'scenario1': {
        'name': scenario1.input.scenario,
        'finalBalance': scenario1.finalBalance,
        'totalGrowth': scenario1.totalGrowth,
      },
      'scenario2': {
        'name': scenario2.input.scenario,
        'finalBalance': scenario2.finalBalance,
        'totalGrowth': scenario2.totalGrowth,
      },
      'difference': {
        'balance': balanceDiff,
        'growth': growthDiff,
        'percentage': (balanceDiff / scenario1.finalBalance) * 100,
      },
      'better': balanceDiff > 0 ? scenario2.input.scenario : scenario1.input.scenario,
    };
  }

  /// Find required savings rate to reach goal
  double findRequiredSavingsRate({
    required double currentBalance,
    required double monthlyIncome,
    required double targetAmount,
    required int months,
  }) {
    // Binary search for required savings rate
    double low = 0.0;
    double high = 1.0;
    double tolerance = 0.001;

    while (high - low > tolerance) {
      final mid = (low + high) / 2;
      final expenses = monthlyIncome * (1 - mid);

      final result = run(SimulationInput(
        startBalance: currentBalance,
        monthlyIncome: monthlyIncome,
        monthlyExpenses: expenses,
        monthlyReturnRate: 0.005,
        months: months,
      ));

      if (result.finalBalance < targetAmount) {
        low = mid;
      } else {
        high = mid;
      }
    }

    return (low + high) / 2;
  }
}
