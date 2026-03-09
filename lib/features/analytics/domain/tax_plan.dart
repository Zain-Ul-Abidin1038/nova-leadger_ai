/// Tax Optimization Plan
/// Contains deduction totals and optimization suggestions
class TaxPlan {
  final double deductibleTotal;
  final List<String> suggestions;
  final Map<String, double> deductionsByCategory;
  final double estimatedTaxSavings;

  TaxPlan({
    required this.deductibleTotal,
    required this.suggestions,
    required this.deductionsByCategory,
    required this.estimatedTaxSavings,
  });

  Map<String, dynamic> toJson() {
    return {
      'deductibleTotal': deductibleTotal,
      'suggestions': suggestions,
      'deductionsByCategory': deductionsByCategory,
      'estimatedTaxSavings': estimatedTaxSavings,
    };
  }

  factory TaxPlan.fromJson(Map<String, dynamic> json) {
    return TaxPlan(
      deductibleTotal: (json['deductibleTotal'] as num).toDouble(),
      suggestions: List<String>.from(json['suggestions'] as List),
      deductionsByCategory: Map<String, double>.from(
        (json['deductionsByCategory'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      ),
      estimatedTaxSavings: (json['estimatedTaxSavings'] as num).toDouble(),
    );
  }
}
