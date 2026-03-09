/// Financial Snapshot for AI Analysis
class FinancialSnapshot {
  final double balance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final Map<String, double> topCategories;
  final double savingsRate;
  final double burnRate;
  final int daysOfRunway;
  final List<String> recentTransactions;

  FinancialSnapshot({
    required this.balance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.topCategories,
    required this.savingsRate,
    required this.burnRate,
    required this.daysOfRunway,
    required this.recentTransactions,
  });

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'topCategories': topCategories,
      'savingsRate': savingsRate,
      'burnRate': burnRate,
      'daysOfRunway': daysOfRunway,
      'recentTransactions': recentTransactions,
    };
  }

  String toPromptContext() {
    return '''
Financial Snapshot:
- Balance: \$${balance.toStringAsFixed(2)}
- Monthly Income: \$${monthlyIncome.toStringAsFixed(2)}
- Monthly Expenses: \$${monthlyExpenses.toStringAsFixed(2)}
- Savings Rate: ${(savingsRate * 100).toStringAsFixed(1)}%
- Burn Rate: \$${burnRate.toStringAsFixed(2)}/day
- Days of Runway: $daysOfRunway days

Top Spending Categories:
${topCategories.entries.map((e) => '- ${e.key}: \$${e.value.toStringAsFixed(2)}').join('\n')}

Recent Transactions:
${recentTransactions.take(5).map((t) => '- $t').join('\n')}
''';
  }
}
