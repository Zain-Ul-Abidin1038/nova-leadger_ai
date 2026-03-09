import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/wealth_plan.dart';

final wealthPlannerProvider = Provider((ref) => WealthPlanner());

/// Wealth Planner
/// Projects long-term wealth trajectory with compound growth
class WealthPlanner {
  /// Generate wealth projection plan
  WealthPlan generate({
    required double currentNetWorth,
    required double monthlySavings,
    required double annualReturnRate,
    int years = 10,
  }) {
    safePrint('[WealthPlanner] Generating ${years}-year plan...');
    safePrint('[WealthPlanner] Starting net worth: ₹${currentNetWorth.toStringAsFixed(0)}');
    safePrint('[WealthPlanner] Monthly savings: ₹${monthlySavings.toStringAsFixed(0)}');
    safePrint('[WealthPlanner] Annual return: ${(annualReturnRate * 100).toStringAsFixed(1)}%');

    final projections = <WealthProjection>[];
    double wealth = currentNetWorth;
    double totalSavings = 0;

    for (int year = 1; year <= years; year++) {
      // Add annual savings
      final annualSavings = monthlySavings * 12;
      totalSavings += annualSavings;
      wealth += annualSavings;

      // Apply investment returns
      final investmentGains = wealth * annualReturnRate;
      wealth += investmentGains;

      projections.add(WealthProjection(
        year: year,
        netWorth: wealth,
        totalSavings: totalSavings,
        investmentGains: investmentGains,
      ));

      safePrint('[WealthPlanner] Year $year: ₹${wealth.toStringAsFixed(0)}');
    }

    final plan = WealthPlan(
      projections: projections,
      currentNetWorth: currentNetWorth,
      monthlySavings: monthlySavings,
      annualReturnRate: annualReturnRate,
      years: years,
      generatedAt: DateTime.now(),
    );

    safePrint('[WealthPlanner] Final net worth: ₹${plan.finalNetWorth.toStringAsFixed(0)}');
    safePrint('[WealthPlanner] Total growth: ₹${plan.totalGrowth.toStringAsFixed(0)} (${plan.growthPercentage.toStringAsFixed(1)}%)');

    return plan;
  }

  /// Assess retirement readiness
  RetirementReadiness assessRetirementReadiness({
    required double currentAge,
    required double retirementAge,
    required double currentNetWorth,
    required double monthlySavings,
    required double annualReturnRate,
    required double requiredNetWorth,
  }) {
    final yearsToRetirement = (retirementAge - currentAge).toInt();

    // Project net worth at retirement
    final plan = generate(
      currentNetWorth: currentNetWorth,
      monthlySavings: monthlySavings,
      annualReturnRate: annualReturnRate,
      years: yearsToRetirement,
    );

    final projectedNetWorth = plan.finalNetWorth;
    final onTrack = projectedNetWorth >= requiredNetWorth;
    final shortfall = onTrack ? 0.0 : requiredNetWorth - projectedNetWorth;

    safePrint('[WealthPlanner] Retirement Assessment:');
    safePrint('[WealthPlanner] Years to retirement: $yearsToRetirement');
    safePrint('[WealthPlanner] Projected: ₹${projectedNetWorth.toStringAsFixed(0)}');
    safePrint('[WealthPlanner] Required: ₹${requiredNetWorth.toStringAsFixed(0)}');
    safePrint('[WealthPlanner] On track: $onTrack');

    return RetirementReadiness(
      currentAge: currentAge,
      retirementAge: retirementAge,
      currentNetWorth: currentNetWorth,
      projectedNetWorth: projectedNetWorth,
      requiredNetWorth: requiredNetWorth,
      onTrack: onTrack,
      shortfall: shortfall,
    );
  }

  /// Calculate required monthly savings to reach goal
  double calculateRequiredSavings({
    required double currentNetWorth,
    required double targetNetWorth,
    required int years,
    required double annualReturnRate,
  }) {
    // Use binary search to find required monthly savings
    double low = 0;
    double high = targetNetWorth / 12 / years;
    double tolerance = 100; // ₹100 tolerance

    while (high - low > tolerance) {
      final mid = (low + high) / 2;
      final plan = generate(
        currentNetWorth: currentNetWorth,
        monthlySavings: mid,
        annualReturnRate: annualReturnRate,
        years: years,
      );

      if (plan.finalNetWorth < targetNetWorth) {
        low = mid;
      } else {
        high = mid;
      }
    }

    final requiredSavings = (low + high) / 2;
    safePrint('[WealthPlanner] Required monthly savings: ₹${requiredSavings.toStringAsFixed(0)}');

    return requiredSavings;
  }

  /// Generate goal-based plan
  WealthPlan generateGoalPlan({
    required double currentNetWorth,
    required double targetNetWorth,
    required int years,
    required double annualReturnRate,
  }) {
    final requiredSavings = calculateRequiredSavings(
      currentNetWorth: currentNetWorth,
      targetNetWorth: targetNetWorth,
      years: years,
      annualReturnRate: annualReturnRate,
    );

    return generate(
      currentNetWorth: currentNetWorth,
      monthlySavings: requiredSavings,
      annualReturnRate: annualReturnRate,
      years: years,
    );
  }

  /// Compare different scenarios
  Map<String, WealthPlan> compareScenarios({
    required double currentNetWorth,
    required double monthlySavings,
    int years = 10,
  }) {
    return {
      'conservative': generate(
        currentNetWorth: currentNetWorth,
        monthlySavings: monthlySavings,
        annualReturnRate: 0.06, // 6% return
        years: years,
      ),
      'moderate': generate(
        currentNetWorth: currentNetWorth,
        monthlySavings: monthlySavings,
        annualReturnRate: 0.10, // 10% return
        years: years,
      ),
      'aggressive': generate(
        currentNetWorth: currentNetWorth,
        monthlySavings: monthlySavings,
        annualReturnRate: 0.15, // 15% return
        years: years,
      ),
    };
  }
}
