/// Negotiation Context
class NegotiationContext {
  final String vendor;
  final double currentAmount;
  final List<double> paymentHistory;
  final String serviceType;
  final int monthsAsCustomer;
  final bool hasCompetitors;

  NegotiationContext({
    required this.vendor,
    required this.currentAmount,
    required this.paymentHistory,
    required this.serviceType,
    required this.monthsAsCustomer,
    this.hasCompetitors = true,
  });

  /// Average payment
  double get averagePayment {
    if (paymentHistory.isEmpty) return currentAmount;
    return paymentHistory.reduce((a, b) => a + b) / paymentHistory.length;
  }

  /// Is loyal customer
  bool get isLoyalCustomer => monthsAsCustomer >= 12;
}

/// Negotiation Strategy
class NegotiationStrategy {
  final String approach; // 'competitive', 'loyalty', 'hardship', 'bundle'
  final double targetAmount;
  final double minimumAcceptable;
  final List<String> leveragePoints;
  final String tone; // 'professional', 'friendly', 'firm'

  NegotiationStrategy({
    required this.approach,
    required this.targetAmount,
    required this.minimumAcceptable,
    required this.leveragePoints,
    required this.tone,
  });

  Map<String, dynamic> toJson() => {
        'approach': approach,
        'targetAmount': targetAmount,
        'minimumAcceptable': minimumAcceptable,
        'leveragePoints': leveragePoints,
        'tone': tone,
      };
}

/// Negotiation Result
class NegotiationResult {
  final double proposedAmount;
  final String message;
  final double successProbability;
  final NegotiationStrategy strategy;
  final double potentialSavings;

  NegotiationResult({
    required this.proposedAmount,
    required this.message,
    required this.successProbability,
    required this.strategy,
    required this.potentialSavings,
  });

  /// High probability of success
  bool get isHighProbability => successProbability >= 0.7;

  Map<String, dynamic> toJson() => {
        'proposedAmount': proposedAmount,
        'message': message,
        'successProbability': successProbability,
        'strategy': strategy.toJson(),
        'potentialSavings': potentialSavings,
      };
}

/// Negotiation Outcome
class NegotiationOutcome {
  final String vendor;
  final double originalAmount;
  final double finalAmount;
  final bool successful;
  final DateTime date;
  final String notes;

  NegotiationOutcome({
    required this.vendor,
    required this.originalAmount,
    required this.finalAmount,
    required this.successful,
    required this.date,
    this.notes = '',
  });

  double get savings => originalAmount - finalAmount;
  double get savingsPercentage => (savings / originalAmount) * 100;
}
