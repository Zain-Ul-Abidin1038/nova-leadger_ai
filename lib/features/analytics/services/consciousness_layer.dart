import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/financial_decision.dart';
import '../domain/agent_result.dart';
import '../domain/financial_context.dart';
import '../../../core/services/nova_service_v3.dart';

final consciousnessLayerProvider = Provider((ref) => ConsciousnessLayer(
      nova: ref.read(novaServiceV3Provider),
    ));

/// Financial Consciousness Layer
/// Makes every AI decision explainable and auditable
class ConsciousnessLayer {
  final NovaServiceV3 nova;

  ConsciousnessLayer({required this.nova});

  /// Explain decision
  Map<String, dynamic> explainDecision(
    FinancialDecision decision,
    List<AgentResult> agentInsights,
  ) {
    safePrint('[ConsciousnessLayer] Explaining decision: ${decision.type}');

    return {
      'decision': decision.message,
      'type': decision.type,
      'priority': decision.priority,
      'confidence': decision.confidence,
      'reasoning': _extractReasoning(decision, agentInsights),
      'contributors': _mapContributors(agentInsights),
      'alternatives': _showAlternatives(decision),
      'impact': _predictImpact(decision),
      'risks': _identifyRisks(decision),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Answer user query about decisions
  Future<String> answerUserQuery(
    String query,
    FinancialContext context,
  ) async {
    safePrint('[ConsciousnessLayer] Answering query: $query');

    final prompt = """
User asked: $query

Financial Context:
- Current balance: \$${context.snapshot.balance}
- Monthly income: \$${context.snapshot.monthlyIncome}
- Monthly expenses: \$${context.snapshot.monthlyExpenses}
- Savings rate: ${(context.twin.savingsRate * 100).toStringAsFixed(1)}%
- Risk tolerance: ${(context.twin.riskTolerance * 100).toStringAsFixed(0)}%

Provide a clear, human-friendly explanation with:
1. Direct answer to the question
2. Supporting data from the context
3. Related insights or recommendations
4. Actionable next steps (if applicable)

Keep the response concise (under 200 words) and conversational.
""";

    try {
      final response = await nova.sendMessage(
        prompt: prompt,
        thinkingLevel: 'high',
      );

      return response['text'] as String;
    } catch (e) {
      safePrint('[ConsciousnessLayer] ❌ Failed to answer query: $e');
      return 'I apologize, but I encountered an error processing your question. Please try rephrasing or ask something else.';
    }
  }

  /// Explain why a decision was made
  Future<String> explainWhy(
    FinancialDecision decision,
    FinancialContext context,
  ) async {
    final prompt = """
Explain why this financial decision was made:

Decision: ${decision.message}
Type: ${decision.type}
Priority: ${decision.priority}/10
Confidence: ${(decision.confidence * 100).toStringAsFixed(0)}%

Context:
- Balance: \$${context.snapshot.balance}
- Monthly income: \$${context.snapshot.monthlyIncome}
- Monthly expenses: \$${context.snapshot.monthlyExpenses}
- Savings rate: ${(context.twin.savingsRate * 100).toStringAsFixed(1)}%

Provide a clear explanation in 2-3 sentences that a non-technical user can understand.
""";

    try {
      final response = await nova.sendMessage(
        prompt: prompt,
        thinkingLevel: 'medium',
      );

      return response['text'] as String;
    } catch (e) {
      return _getFallbackExplanation(decision);
    }
  }

  /// Explain what would happen if...
  Future<String> explainWhatIf(
    String scenario,
    FinancialContext context,
  ) async {
    final prompt = """
Analyze this "what if" scenario:

Scenario: $scenario

Current Financial State:
- Balance: \$${context.snapshot.balance}
- Monthly income: \$${context.snapshot.monthlyIncome}
- Monthly expenses: \$${context.snapshot.monthlyExpenses}
- Savings rate: ${(context.twin.savingsRate * 100).toStringAsFixed(1)}%

Explain:
1. What would change
2. Impact on financial health
3. Recommended actions
4. Timeline to see results

Keep it concise and actionable.
""";

    try {
      final response = await nova.sendMessage(
        prompt: prompt,
        thinkingLevel: 'high',
      );

      return response['text'] as String;
    } catch (e) {
      return 'Unable to simulate this scenario at the moment. Please try again.';
    }
  }

  /// Extract reasoning
  List<String> _extractReasoning(
    FinancialDecision decision,
    List<AgentResult> agentInsights,
  ) {
    final reasoning = <String>[];

    // Add decision-specific reasoning
    reasoning.add('Priority ${decision.priority}/10 based on urgency and impact');
    reasoning.add('Confidence ${(decision.confidence * 100).toStringAsFixed(0)}% from agent analysis');

    // Add agent insights
    for (final agent in agentInsights) {
      if (agent.recommendations.any((r) => decision.message.contains(r))) {
        reasoning.add('${agent.agentName} identified this opportunity');
      }
    }

    return reasoning;
  }

  /// Map contributors
  List<Map<String, dynamic>> _mapContributors(List<AgentResult> agentInsights) {
    return agentInsights.map((agent) {
      return {
        'agent': agent.agentName,
        'type': agent.agentType,
        'confidence': agent.confidence,
        'recommendations': agent.recommendations.length,
      };
    }).toList();
  }

  /// Show alternatives
  List<String> _showAlternatives(FinancialDecision decision) {
    // Generate alternative actions based on decision type
    switch (decision.type) {
      case 'adjust_budget':
        return [
          'Maintain current budget and increase income',
          'Reduce expenses in specific categories',
          'Delay budget adjustment for 1 month',
        ];
      case 'increase_savings':
        return [
          'Reduce discretionary spending',
          'Automate savings transfers',
          'Find additional income sources',
        ];
      case 'build_emergency_fund':
        return [
          'Set aside 10% of income monthly',
          'Use windfalls (bonuses, tax refunds)',
          'Reduce non-essential subscriptions',
        ];
      default:
        return [
          'Take no action and monitor',
          'Implement gradually over 3 months',
          'Seek professional financial advice',
        ];
    }
  }

  /// Predict impact
  Map<String, dynamic> _predictImpact(FinancialDecision decision) {
    // Estimate impact based on decision type
    return {
      'timeframe': _getTimeframe(decision.priority),
      'financialImpact': _getFinancialImpact(decision.type),
      'riskLevel': decision.priority >= 8 ? 'high' : 'medium',
      'reversible': _isReversible(decision.type),
    };
  }

  /// Identify risks
  List<String> _identifyRisks(FinancialDecision decision) {
    final risks = <String>[];

    if (decision.priority >= 8) {
      risks.add('High priority - delayed action may worsen situation');
    }

    if (decision.confidence < 0.7) {
      risks.add('Lower confidence - consider additional analysis');
    }

    switch (decision.type) {
      case 'adjust_budget':
        risks.add('May require lifestyle changes');
        break;
      case 'increase_savings':
        risks.add('Could reduce short-term liquidity');
        break;
      case 'build_emergency_fund':
        risks.add('Opportunity cost of not investing');
        break;
    }

    return risks;
  }

  String _getTimeframe(int priority) {
    if (priority >= 8) return 'Immediate (within 1 week)';
    if (priority >= 5) return 'Short-term (within 1 month)';
    return 'Long-term (within 3 months)';
  }

  String _getFinancialImpact(String type) {
    switch (type) {
      case 'adjust_budget':
        return 'Medium - affects monthly cashflow';
      case 'increase_savings':
        return 'High - improves long-term wealth';
      case 'build_emergency_fund':
        return 'High - reduces financial risk';
      default:
        return 'Medium - varies by implementation';
    }
  }

  bool _isReversible(String type) {
    // Most financial decisions are reversible
    return !['sell_investment', 'close_account'].contains(type);
  }

  String _getFallbackExplanation(FinancialDecision decision) {
    return 'This decision was recommended based on analysis of your financial situation. '
        'It has a priority of ${decision.priority}/10 and confidence of ${(decision.confidence * 100).toStringAsFixed(0)}%. '
        'The system identified this as an opportunity to improve your financial health.';
  }

  /// Generate executive summary
  String generateExecutiveSummary(
    List<FinancialDecision> decisions,
    List<AgentResult> agentInsights,
  ) {
    final summary = StringBuffer();

    summary.writeln('🧠 Financial Intelligence Summary\n');

    // Agent insights
    summary.writeln('📊 Analysis from ${agentInsights.length} specialized agents:');
    for (final agent in agentInsights) {
      summary.writeln('  • ${agent.agentName}: ${(agent.confidence * 100).toStringAsFixed(0)}% confidence');
    }

    summary.writeln();

    // Decisions
    final urgent = decisions.where((d) => d.priority >= 8).length;
    final important = decisions.where((d) => d.priority >= 5 && d.priority < 8).length;

    summary.writeln('🎯 Generated ${decisions.length} recommendations:');
    if (urgent > 0) summary.writeln('  • $urgent urgent actions required');
    if (important > 0) summary.writeln('  • $important important actions suggested');

    return summary.toString();
  }
}
