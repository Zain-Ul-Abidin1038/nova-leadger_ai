/// Wealth Projection Model
/// Represents net worth projection for a specific year
class WealthProjection {
  final int year;
  final double netWorth;
  final double totalSavings;
  final double investmentGains;

  WealthProjection({
    required this.year,
    required this.netWorth,
    required this.totalSavings,
    required this.investmentGains,
  });
}

/// Wealth Plan Model
/// Long-term wealth trajectory over multiple years
class WealthPlan {
  final List<WealthProjection> projections;
  final double currentNetWorth;
  final double monthlySavings;
  final double annualReturnRate;
  final int years;
  final DateTime generatedAt;

  WealthPlan({
    required this.projections,
    required this.currentNetWorth,
    required this.monthlySavings,
    required this.annualReturnRate,
    required this.years,
    required this.generatedAt,
  });

  double get finalNetWorth => projections.last.netWorth;
  
  double get totalGrowth => finalNetWorth - currentNetWorth;
  
  double get growthPercentage => 
      ((finalNetWorth - currentNetWorth) / currentNetWorth) * 100;

  WealthProjection? getProjectionForYear(int year) {
    try {
      return projections.firstWhere((p) => p.year == year);
    } catch (_) {
      return null;
    }
  }
}

/// Retirement Readiness Assessment
class RetirementReadiness {
  final double currentAge;
  final double retirementAge;
  final double currentNetWorth;
  final double projectedNetWorth;
  final double requiredNetWorth;
  final bool onTrack;
  final double shortfall;

  RetirementReadiness({
    required this.currentAge,
    required this.retirementAge,
    required this.currentNetWorth,
    required this.projectedNetWorth,
    required this.requiredNetWorth,
    required this.onTrack,
    required this.shortfall,
  });

  double get yearsToRetirement => retirementAge - currentAge;
  
  double get readinessPercentage => 
      (projectedNetWorth / requiredNetWorth) * 100;
}
