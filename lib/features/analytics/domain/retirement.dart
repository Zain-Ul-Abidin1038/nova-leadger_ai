/// Retirement Goals
class RetirementGoals {
  final int retirementAge;
  final double desiredMonthlyIncome;
  final int yearsInRetirement;
  final double inflationRate;
  final double expectedReturn;

  RetirementGoals({
    required this.retirementAge,
    required this.desiredMonthlyIncome,
    this.yearsInRetirement = 30,
    this.inflationRate = 0.03,
    this.expectedReturn = 0.07,
  });

  /// Annual income needed
  double get annualIncome => desiredMonthlyIncome * 12;
}

/// Retirement Trajectory
class RetirementTrajectory {
  final List<double> yearlyBalances;
  final double finalAmount;
  final int yearsToRetirement;

  RetirementTrajectory({
    required this.yearlyBalances,
    required this.finalAmount,
    required this.yearsToRetirement,
  });

  /// Average annual growth
  double get averageAnnualGrowth {
    if (yearlyBalances.length < 2) return 0;
    final first = yearlyBalances.first;
    final last = yearlyBalances.last;
    return ((last - first) / first) / yearlyBalances.length;
  }
}

/// Withdrawal Strategy
class WithdrawalStrategy {
  final double safeWithdrawalRate;
  final double monthlyWithdrawal;
  final int yearsOfSustainability;
  final Map<String, dynamic> taxOptimization;

  WithdrawalStrategy({
    required this.safeWithdrawalRate,
    required this.monthlyWithdrawal,
    required this.yearsOfSustainability,
    this.taxOptimization = const {},
  });

  /// Is sustainable
  bool get isSustainable => yearsOfSustainability >= 30;
}

/// Retirement Plan
class RetirementPlan {
  final double corpusNeeded;
  final RetirementTrajectory currentProjection;
  final double gap;
  final Map<String, dynamic> catchUpPlan;
  final List<Map<String, dynamic>> scenarios;
  final WithdrawalStrategy withdrawalStrategy;
  final double readiness;

  RetirementPlan({
    required this.corpusNeeded,
    required this.currentProjection,
    required this.gap,
    required this.catchUpPlan,
    required this.scenarios,
    required this.withdrawalStrategy,
    required this.readiness,
  });

  /// Is on track
  bool get isOnTrack => readiness >= 0.8;

  /// Needs catch-up
  bool get needsCatchUp => gap > corpusNeeded * 0.2;

  Map<String, dynamic> toJson() => {
        'corpusNeeded': corpusNeeded,
        'currentProjection': currentProjection.finalAmount,
        'gap': gap,
        'readiness': readiness,
        'isOnTrack': isOnTrack,
        'needsCatchUp': needsCatchUp,
      };
}
