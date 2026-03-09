import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/financial_snapshot.dart';

final netWorthOptimizerProvider = Provider((ref) => NetWorthOptimizer());

class OptimizationPlan {
  final double investAmount;
  final double emergencyFundContribution;
  final double discretionaryCap;
  final double debtPayment;
  final Map<String, double> categoryLimits;

  OptimizationPlan({
    required this.investAmount,
    required this.emergencyFundContribution,
    required this.discretionaryCap,
    required this.debtPayment,
    required this.categoryLimits,
  });
}

class NetWorthOptimizer {
  OptimizationPlan optimize(FinancialSnapshot snapshot) {
    safePrint('[NetWorthOptimizer] Optimizing...');

    final monthlySavings = snapshot.monthlyIncome - snapshot.monthlyExpenses;
    final hasEmergencyFund = snapshot.runwayMonths >= 6;

    double investmentRate = hasEmergencyFund ? 0.60 : 0.30;
    double emergencyRate = hasEmergencyFund ? 0.15 : 0.50;

    return OptimizationPlan(
      investAmount: monthlySavings * investmentRate,
      emergencyFundContribution: monthlySavings * emergencyRate,
      discretionaryCap: snapshot.monthlyIncome * 0.80,
      debtPayment: monthlySavings * 0.25,
      categoryLimits: {},
    );
  }
}
