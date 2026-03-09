import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:math';
import '../domain/retirement.dart';
import '../domain/financial_context.dart';

final retirementEngineProvider = Provider((ref) => RetirementEngine());

/// Retirement Intelligence Engine
/// Comprehensive retirement planning and simulation
class RetirementEngine {
  /// Simulate retirement
  Future<RetirementPlan> simulateRetirement(
    EconomicDigitalTwin twin,
    RetirementGoals goals,
    int currentAge,
  ) async {
    safePrint('[RetirementEngine] Simulating retirement...');
    safePrint('[RetirementEngine] Current age: $currentAge, Retirement age: ${goals.retirementAge}');

    // 1. Calculate corpus needed
    final corpusNeeded = _calculateCorpus(goals);
    safePrint('[RetirementEngine] Corpus needed: \$${corpusNeeded.toStringAsFixed(0)}');

    // 2. Project current trajectory
    final currentTrajectory = _projectTrajectory(twin, currentAge, goals);
    safePrint('[RetirementEngine] Projected corpus: \$${currentTrajectory.finalAmount.toStringAsFixed(0)}');

    // 3. Calculate gap
    final gap = corpusNeeded - currentTrajectory.finalAmount;
    safePrint('[RetirementEngine] Gap: \$${gap.toStringAsFixed(0)}');

    // 4. Generate catch-up plan
    final catchUpPlan = _generateCatchUpPlan(gap, twin, currentAge, goals);
    safePrint('[RetirementEngine] Catch-up required: \$${catchUpPlan['monthlyIncrease']}');

    // 5. Simulate scenarios
    final scenarios = _simulateScenarios(twin, currentAge, goals);
    safePrint('[RetirementEngine] Generated ${scenarios.length} scenarios');

    // 6. Optimize withdrawal strategy
    final withdrawalStrategy = _optimizeWithdrawals(corpusNeeded, goals);
    safePrint('[RetirementEngine] Safe withdrawal: \$${withdrawalStrategy.monthlyWithdrawal}/month');

    // 7. Calculate readiness
    final readiness = _calculateReadiness(currentTrajectory.finalAmount, corpusNeeded);
    safePrint('[RetirementEngine] Readiness: ${(readiness * 100).toStringAsFixed(0)}%');

    return RetirementPlan(
      corpusNeeded: corpusNeeded,
      currentProjection: currentTrajectory,
      gap: gap,
      catchUpPlan: catchUpPlan,
      scenarios: scenarios,
      withdrawalStrategy: withdrawalStrategy,
      readiness: readiness,
    );
  }

  /// Calculate retirement corpus needed
  double _calculateCorpus(RetirementGoals goals) {
    // Using the 4% rule adjusted for inflation
    // Corpus = Annual expenses / Safe withdrawal rate
    final annualIncome = goals.annualIncome;
    final safeWithdrawalRate = 0.04;

    // Adjust for inflation over retirement years
    final inflationMultiplier = pow(1 + goals.inflationRate, goals.yearsInRetirement / 2);
    final adjustedAnnualIncome = annualIncome * inflationMultiplier;

    return adjustedAnnualIncome / safeWithdrawalRate;
  }

  /// Project current trajectory
  RetirementTrajectory _projectTrajectory(
    EconomicDigitalTwin twin,
    int currentAge,
    RetirementGoals goals,
  ) {
    final yearsToRetirement = goals.retirementAge - currentAge;
    final yearlyBalances = <double>[];

    double balance = twin.balance;
    final monthlySavings = twin.monthlyIncome - twin.monthlyExpenses;
    final annualReturn = goals.expectedReturn;

    for (int year = 0; year <= yearsToRetirement; year++) {
      yearlyBalances.add(balance);

      // Add annual savings
      balance += monthlySavings * 12;

      // Apply investment returns
      balance *= (1 + annualReturn);
    }

    return RetirementTrajectory(
      yearlyBalances: yearlyBalances,
      finalAmount: balance,
      yearsToRetirement: yearsToRetirement,
    );
  }

  /// Generate catch-up plan
  Map<String, dynamic> _generateCatchUpPlan(
    double gap,
    EconomicDigitalTwin twin,
    int currentAge,
    RetirementGoals goals,
  ) {
    if (gap <= 0) {
      return {
        'needed': false,
        'monthlyIncrease': 0.0,
        'actions': ['You are on track for retirement!'],
      };
    }

    final yearsToRetirement = goals.retirementAge - currentAge;
    final annualReturn = goals.expectedReturn;

    // Calculate additional monthly savings needed
    // Using future value of annuity formula
    final monthlyRate = annualReturn / 12;
    final months = yearsToRetirement * 12;

    final monthlyIncrease = gap * monthlyRate / (pow(1 + monthlyRate, months) - 1);

    final actions = <String>[];
    actions.add('Increase monthly savings by \$${monthlyIncrease.toStringAsFixed(2)}');

    if (monthlyIncrease > twin.monthlyIncome * 0.1) {
      actions.add('Consider working ${(monthlyIncrease / (twin.monthlyIncome * 0.1)).ceil()} additional years');
      actions.add('Explore higher-return investment options');
      actions.add('Reduce planned retirement expenses');
    }

    return {
      'needed': true,
      'gap': gap,
      'monthlyIncrease': monthlyIncrease,
      'yearsToRetirement': yearsToRetirement,
      'actions': actions,
    };
  }

  /// Simulate scenarios
  List<Map<String, dynamic>> _simulateScenarios(
    EconomicDigitalTwin twin,
    int currentAge,
    RetirementGoals goals,
  ) {
    final scenarios = <Map<String, dynamic>>[];

    // Best case (higher returns)
    final bestGoals = RetirementGoals(
      retirementAge: goals.retirementAge,
      desiredMonthlyIncome: goals.desiredMonthlyIncome,
      expectedReturn: goals.expectedReturn + 0.02,
    );
    final bestTrajectory = _projectTrajectory(twin, currentAge, bestGoals);
    scenarios.add({
      'name': 'Best Case',
      'description': 'Higher investment returns (+2%)',
      'finalAmount': bestTrajectory.finalAmount,
      'probability': 0.25,
    });

    // Expected case (current trajectory)
    final expectedTrajectory = _projectTrajectory(twin, currentAge, goals);
    scenarios.add({
      'name': 'Expected Case',
      'description': 'Current savings and returns',
      'finalAmount': expectedTrajectory.finalAmount,
      'probability': 0.50,
    });

    // Worst case (lower returns)
    final worstGoals = RetirementGoals(
      retirementAge: goals.retirementAge,
      desiredMonthlyIncome: goals.desiredMonthlyIncome,
      expectedReturn: goals.expectedReturn - 0.02,
    );
    final worstTrajectory = _projectTrajectory(twin, currentAge, worstGoals);
    scenarios.add({
      'name': 'Worst Case',
      'description': 'Lower investment returns (-2%)',
      'finalAmount': worstTrajectory.finalAmount,
      'probability': 0.25,
    });

    return scenarios;
  }

  /// Optimize withdrawal strategy
  WithdrawalStrategy _optimizeWithdrawals(
    double corpus,
    RetirementGoals goals,
  ) {
    // Use 4% rule as baseline
    final safeWithdrawalRate = 0.04;
    final annualWithdrawal = corpus * safeWithdrawalRate;
    final monthlyWithdrawal = annualWithdrawal / 12;

    // Calculate sustainability
    final yearsOfSustainability = _calculateSustainability(
      corpus,
      annualWithdrawal,
      goals.expectedReturn,
      goals.inflationRate,
    );

    return WithdrawalStrategy(
      safeWithdrawalRate: safeWithdrawalRate,
      monthlyWithdrawal: monthlyWithdrawal,
      yearsOfSustainability: yearsOfSustainability,
      taxOptimization: {
        'strategy': 'Withdraw from taxable accounts first',
        'estimatedTaxSavings': annualWithdrawal * 0.15,
      },
    );
  }

  /// Calculate sustainability years
  int _calculateSustainability(
    double corpus,
    double annualWithdrawal,
    double returnRate,
    double inflationRate,
  ) {
    double balance = corpus;
    int years = 0;

    while (balance > 0 && years < 50) {
      // Withdraw (adjusted for inflation)
      final withdrawal = annualWithdrawal * pow(1 + inflationRate, years);
      balance -= withdrawal;

      // Apply returns
      balance *= (1 + returnRate);

      years++;
    }

    return years;
  }

  /// Calculate readiness score
  double _calculateReadiness(double projected, double needed) {
    if (needed == 0) return 1.0;
    return (projected / needed).clamp(0.0, 1.0);
  }

  /// Estimate healthcare costs
  double estimateHealthcareCosts(int retirementAge) {
    // Average healthcare costs increase with age
    final baseAnnualCost = 5000.0;
    final ageMultiplier = 1 + ((retirementAge - 65) * 0.05);
    return baseAnnualCost * ageMultiplier;
  }
}
