import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/user_financial_profile.dart';
import '../domain/wealth_plan.dart';
import 'wealth_planner.dart';

final scenarioModelerProvider = Provider((ref) => ScenarioModeler(
      planner: ref.read(wealthPlannerProvider),
    ));

/// Scenario Bundle
/// Contains best/expected/worst case projections
class ScenarioBundle {
  final WealthPlan best;
  final WealthPlan expected;
  final WealthPlan worst;
  final DateTime generatedAt;

  ScenarioBundle({
    required this.best,
    required this.expected,
    required this.worst,
    required this.generatedAt,
  });

  /// Get scenario by name
  WealthPlan getScenario(String name) {
    switch (name.toLowerCase()) {
      case 'best':
        return best;
      case 'worst':
        return worst;
      default:
        return expected;
    }
  }

  /// Get range at year
  Map<String, double> getRangeAtYear(int year) {
    final bestProjection = best.getProjectionForYear(year);
    final expectedProjection = expected.getProjectionForYear(year);
    final worstProjection = worst.getProjectionForYear(year);

    return {
      'best': bestProjection?.netWorth ?? 0,
      'expected': expectedProjection?.netWorth ?? 0,
      'worst': worstProjection?.netWorth ?? 0,
    };
  }
}

/// Scenario Modeler
/// Generates multi-year best/expected/worst case futures
class ScenarioModeler {
  final WealthPlanner planner;

  ScenarioModeler({required this.planner});

  /// Generate scenario bundle
  Future<ScenarioBundle> generate(UserFinancialProfile profile) async {
    safePrint('[ScenarioModeler] Generating scenarios...');

    final base = profile.snapshot;

    // Best case: Income +10%, Expenses -10%, 12% returns
    final best = _projectScenario(
      base: base,
      incomeFactor: 1.1,
      expenseFactor: 0.9,
      returnRate: 0.12,
      name: 'Best Case',
    );

    // Expected case: Income stable, Expenses stable, 8% returns
    final expected = _projectScenario(
      base: base,
      incomeFactor: 1.0,
      expenseFactor: 1.0,
      returnRate: 0.08,
      name: 'Expected Case',
    );

    // Worst case: Income -20%, Expenses +20%, 4% returns
    final worst = _projectScenario(
      base: base,
      incomeFactor: 0.8,
      expenseFactor: 1.2,
      returnRate: 0.04,
      name: 'Worst Case',
    );

    safePrint('[ScenarioModeler] Best: ₹${best.finalNetWorth.toStringAsFixed(0)}');
    safePrint('[ScenarioModeler] Expected: ₹${expected.finalNetWorth.toStringAsFixed(0)}');
    safePrint('[ScenarioModeler] Worst: ₹${worst.finalNetWorth.toStringAsFixed(0)}');

    return ScenarioBundle(
      best: best,
      expected: expected,
      worst: worst,
      generatedAt: DateTime.now(),
    );
  }

  WealthPlan _projectScenario({
    required dynamic base,
    required double incomeFactor,
    required double expenseFactor,
    required double returnRate,
    required String name,
  }) {
    final adjustedIncome = base.monthlyIncome * incomeFactor;
    final adjustedExpenses = base.monthlyExpenses * expenseFactor;
    final monthlySavings = adjustedIncome - adjustedExpenses;

    safePrint('[ScenarioModeler] $name: Income=₹${adjustedIncome.toStringAsFixed(0)}, Expenses=₹${adjustedExpenses.toStringAsFixed(0)}, Savings=₹${monthlySavings.toStringAsFixed(0)}');

    return planner.generate(
      currentNetWorth: base.balance,
      monthlySavings: monthlySavings.clamp(0, double.infinity),
      annualReturnRate: returnRate,
      years: 10,
    );
  }

  /// Generate custom scenario
  WealthPlan generateCustomScenario({
    required double currentNetWorth,
    required double monthlyIncome,
    required double monthlyExpenses,
    required double annualReturnRate,
    int years = 10,
  }) {
    final monthlySavings = monthlyIncome - monthlyExpenses;

    return planner.generate(
      currentNetWorth: currentNetWorth,
      monthlySavings: monthlySavings,
      annualReturnRate: annualReturnRate,
      years: years,
    );
  }

  /// Generate life event scenarios
  Map<String, WealthPlan> generateLifeEventScenarios({
    required UserFinancialProfile profile,
  }) {
    final base = profile.snapshot;

    return {
      'job_loss': _projectScenario(
        base: base,
        incomeFactor: 0.0,
        expenseFactor: 0.7, // Reduced expenses
        returnRate: 0.05,
        name: 'Job Loss',
      ),
      'promotion': _projectScenario(
        base: base,
        incomeFactor: 1.3,
        expenseFactor: 1.1, // Lifestyle inflation
        returnRate: 0.10,
        name: 'Promotion',
      ),
      'major_expense': _projectScenario(
        base: base,
        incomeFactor: 1.0,
        expenseFactor: 1.5, // Temporary spike
        returnRate: 0.08,
        name: 'Major Expense',
      ),
      'side_income': _projectScenario(
        base: base,
        incomeFactor: 1.2,
        expenseFactor: 1.0,
        returnRate: 0.10,
        name: 'Side Income',
      ),
    };
  }
}
