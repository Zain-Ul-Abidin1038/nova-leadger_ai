import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/negotiation.dart';
import '../../../core/services/nova_service_v3.dart';

final negotiationEngineProvider = Provider((ref) => NegotiationEngine(
      nova: ref.read(novaServiceV3Provider),
    ));

/// AI Negotiation Engine
/// Automatically negotiates bills, subscriptions, and contracts
class NegotiationEngine {
  final NovaServiceV3 nova;

  NegotiationEngine({required this.nova});

  /// Negotiate bill
  Future<NegotiationResult> negotiateBill({
    required String vendor,
    required double currentAmount,
    required NegotiationContext context,
  }) async {
    safePrint('[NegotiationEngine] Analyzing negotiation opportunity...');
    safePrint('[NegotiationEngine] Vendor: $vendor, Amount: \$$currentAmount');

    // 1. Analyze opportunity
    final analysis = await _analyzeOpportunity(vendor, currentAmount, context);
    safePrint('[NegotiationEngine] Opportunity score: ${analysis['score']}');

    // 2. Generate strategy
    final strategy = await _generateStrategy(analysis, context);
    safePrint('[NegotiationEngine] Strategy: ${strategy.approach}');

    // 3. Draft message
    final message = await _draftMessage(strategy, context);
    safePrint('[NegotiationEngine] Message drafted');

    // 4. Predict success
    final probability = _predictSuccess(vendor, strategy, context);
    safePrint('[NegotiationEngine] Success probability: ${(probability * 100).toStringAsFixed(0)}%');

    final potentialSavings = currentAmount - strategy.targetAmount;

    return NegotiationResult(
      proposedAmount: strategy.targetAmount,
      message: message,
      successProbability: probability,
      strategy: strategy,
      potentialSavings: potentialSavings,
    );
  }

  /// Analyze negotiation opportunity
  Future<Map<String, dynamic>> _analyzeOpportunity(
    String vendor,
    double currentAmount,
    NegotiationContext context,
  ) async {
    // Factors that improve negotiation success:
    // - Long customer tenure
    // - Competitive market
    // - High payment amount
    // - Consistent payment history

    double opportunityScore = 0.5; // Base score

    if (context.isLoyalCustomer) opportunityScore += 0.2;
    if (context.hasCompetitors) opportunityScore += 0.15;
    if (currentAmount > 100) opportunityScore += 0.1;
    if (context.paymentHistory.length >= 6) opportunityScore += 0.05;

    return {
      'score': opportunityScore.clamp(0.0, 1.0),
      'isLoyalCustomer': context.isLoyalCustomer,
      'hasCompetitors': context.hasCompetitors,
      'marketRate': currentAmount * 0.85, // Assume 15% below current is market
    };
  }

  /// Generate negotiation strategy
  Future<NegotiationStrategy> _generateStrategy(
    Map<String, dynamic> analysis,
    NegotiationContext context,
  ) async {
    final opportunityScore = analysis['score'] as double;
    final marketRate = analysis['marketRate'] as double;

    // Determine approach
    String approach;
    if (context.isLoyalCustomer) {
      approach = 'loyalty';
    } else if (context.hasCompetitors) {
      approach = 'competitive';
    } else {
      approach = 'bundle';
    }

    // Calculate target (aim for 10-20% reduction)
    final targetReduction = opportunityScore > 0.7 ? 0.20 : 0.10;
    final targetAmount = context.currentAmount * (1 - targetReduction);
    final minimumAcceptable = context.currentAmount * 0.90; // Accept 10% minimum

    // Leverage points
    final leveragePoints = <String>[];
    if (context.isLoyalCustomer) {
      leveragePoints.add('${context.monthsAsCustomer} months of loyalty');
    }
    if (context.hasCompetitors) {
      leveragePoints.add('Competitive offers available');
    }
    if (context.paymentHistory.isNotEmpty) {
      leveragePoints.add('Consistent payment history');
    }

    return NegotiationStrategy(
      approach: approach,
      targetAmount: targetAmount,
      minimumAcceptable: minimumAcceptable,
      leveragePoints: leveragePoints,
      tone: 'professional',
    );
  }

  /// Draft negotiation message
  Future<String> _draftMessage(
    NegotiationStrategy strategy,
    NegotiationContext context,
  ) async {
    final prompt = """
Draft a professional negotiation email for reducing a bill.

Context:
- Vendor: ${context.vendor}
- Current amount: \$${context.currentAmount}
- Target amount: \$${strategy.targetAmount}
- Customer tenure: ${context.monthsAsCustomer} months
- Approach: ${strategy.approach}
- Leverage points: ${strategy.leveragePoints.join(', ')}

Requirements:
- Professional and respectful tone
- Mention loyalty and payment history
- Reference competitive market rates
- Request specific discount to target amount
- Keep it concise (under 200 words)
- End with clear call to action

Generate the email body only (no subject line).
""";

    try {
      final response = await nova.sendMessage(
        prompt: prompt,
        thinkingLevel: 'low',
      );

      return response['text'] as String;
    } catch (e) {
      safePrint('[NegotiationEngine] ❌ Failed to draft message: $e');
      // Fallback template
      return _getFallbackMessage(strategy, context);
    }
  }

  /// Predict success probability
  double _predictSuccess(
    String vendor,
    NegotiationStrategy strategy,
    NegotiationContext context,
  ) {
    double probability = 0.5; // Base probability

    // Factors that increase success
    if (context.isLoyalCustomer) probability += 0.15;
    if (context.hasCompetitors) probability += 0.15;
    if (strategy.leveragePoints.length >= 3) probability += 0.1;
    if (strategy.targetAmount >= strategy.minimumAcceptable) probability += 0.05;

    // Factors that decrease success
    final reductionPercent =
        (context.currentAmount - strategy.targetAmount) / context.currentAmount;
    if (reductionPercent > 0.25) probability -= 0.15; // Asking for too much

    return probability.clamp(0.0, 1.0);
  }

  /// Fallback message template
  String _getFallbackMessage(
    NegotiationStrategy strategy,
    NegotiationContext context,
  ) {
    return """
Dear ${context.vendor} Customer Service,

I have been a loyal customer for ${context.monthsAsCustomer} months and have consistently maintained my account in good standing. I am writing to discuss my current billing rate of \$${context.currentAmount.toStringAsFixed(2)}.

${strategy.leveragePoints.isNotEmpty ? 'Given my ${strategy.leveragePoints.join(', ')}, ' : ''}I would like to request a rate adjustment to \$${strategy.targetAmount.toStringAsFixed(2)} per month. I have researched competitive rates in the market and believe this adjustment would be fair and mutually beneficial.

I value the service you provide and would prefer to continue our relationship. Could you please review my account and let me know if this adjustment is possible?

Thank you for your consideration. I look forward to your response.

Best regards
""";
  }

  /// Execute negotiation (send message)
  Future<void> executeNegotiation(NegotiationResult result) async {
    safePrint('[NegotiationEngine] Executing negotiation...');
    // TODO: Integrate with email/chat service
    // await EmailService().send(result.message);
    safePrint('[NegotiationEngine] ✅ Negotiation message ready to send');
  }

  /// Learn from outcome
  Future<void> learnFromOutcome(NegotiationOutcome outcome) async {
    safePrint('[NegotiationEngine] Learning from outcome...');
    safePrint('[NegotiationEngine] Success: ${outcome.successful}');
    safePrint('[NegotiationEngine] Savings: \$${outcome.savings}');

    // TODO: Store outcome for future learning
    // This would feed into a learning memory system
  }
}
