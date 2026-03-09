import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/agent_result.dart';
import '../domain/financial_decision.dart';

final decisionArbiterProvider = Provider((ref) => DecisionArbiter());

/// Decision Arbiter
/// Resolves conflicts between agent recommendations and synthesizes final decisions
class DecisionArbiter {
  /// Arbitrate between conflicting agent results
  List<FinancialDecision> arbitrate(List<AgentResult> agentResults) {
    safePrint('[DecisionArbiter] Arbitrating ${agentResults.length} agent results...');

    final decisions = <FinancialDecision>[];

    // Group by recommendation type
    final recommendationMap = <String, List<AgentResult>>{};
    for (final result in agentResults) {
      for (final rec in result.recommendations) {
        recommendationMap.putIfAbsent(rec, () => []).add(result);
      }
    }

    // Create decisions from consensus
    for (final entry in recommendationMap.entries) {
      final recommendation = entry.key;
      final supportingAgents = entry.value;

      // Calculate consensus strength
      final avgConfidence = supportingAgents
              .map((a) => a.confidence)
              .reduce((a, b) => a + b) /
          supportingAgents.length;

      // Determine priority based on agent priorities and confidence
      final maxAgentPriority =
          supportingAgents.map((a) => _getAgentPriority(a.agentType)).reduce(
                (a, b) => a > b ? a : b,
              );

      final priority = _calculateDecisionPriority(
        avgConfidence,
        maxAgentPriority,
        supportingAgents.length,
      );

      decisions.add(FinancialDecision(
        type: _inferDecisionType(recommendation),
        message: recommendation,
        priority: priority,
        confidence: avgConfidence,
        metadata: {
          'supportingAgents': supportingAgents.map((a) => a.agentName).toList(),
          'agentCount': supportingAgents.length,
          'consensusStrength': avgConfidence,
        },
      ));
    }

    // Sort by priority (highest first)
    decisions.sort((a, b) => b.priority.compareTo(a.priority));

    safePrint('[DecisionArbiter] Generated ${decisions.length} decisions');
    return decisions;
  }

  /// Resolve conflicts between agents
  FinancialDecision? resolveConflict(
    List<AgentResult> conflictingResults,
  ) {
    if (conflictingResults.isEmpty) return null;

    safePrint('[DecisionArbiter] Resolving conflict between ${conflictingResults.length} agents');

    // Use highest confidence agent
    final winner = conflictingResults.reduce(
      (a, b) => a.confidence > b.confidence ? a : b,
    );

    // But lower priority due to conflict
    final avgPriority = _getAgentPriority(winner.agentType);
    final conflictPenalty = conflictingResults.length > 2 ? 2 : 1;

    return FinancialDecision(
      type: 'review_conflict',
      message: 'Review conflicting recommendations: ${winner.recommendations.first}',
      priority: (avgPriority - conflictPenalty).clamp(1, 10),
      confidence: winner.confidence * 0.8, // Reduce confidence due to conflict
      metadata: {
        'winningAgent': winner.agentName,
        'conflictingAgents': conflictingResults.map((a) => a.agentName).toList(),
        'reason': 'Multiple agents provided conflicting recommendations',
      },
    );
  }

  /// Synthesize insights from all agents
  Map<String, dynamic> synthesizeInsights(List<AgentResult> agentResults) {
    final synthesis = <String, dynamic>{};

    // Aggregate insights by type
    for (final result in agentResults) {
      synthesis[result.agentType] = result.insights;
    }

    // Calculate overall confidence
    final avgConfidence = agentResults.isEmpty
        ? 0.0
        : agentResults.map((a) => a.confidence).reduce((a, b) => a + b) /
            agentResults.length;

    synthesis['overallConfidence'] = avgConfidence;
    synthesis['agentCount'] = agentResults.length;
    synthesis['highConfidenceCount'] =
        agentResults.where((a) => a.isHighConfidence).length;

    return synthesis;
  }

  int _getAgentPriority(String agentType) {
    switch (agentType) {
      case 'health':
        return 10;
      case 'risk':
        return 9;
      case 'cashflow':
      case 'tax':
        return 8;
      case 'goal':
        return 7;
      default:
        return 5;
    }
  }

  int _calculateDecisionPriority(
    double confidence,
    int agentPriority,
    int supportCount,
  ) {
    // Base priority from agent
    double priority = agentPriority.toDouble();

    // Boost for high confidence
    if (confidence > 0.9) priority += 1;

    // Boost for multiple agents agreeing
    if (supportCount > 2) priority += 1;

    return priority.round().clamp(1, 10);
  }

  String _inferDecisionType(String recommendation) {
    final lower = recommendation.toLowerCase();

    if (lower.contains('budget')) return 'adjust_budget';
    if (lower.contains('savings') || lower.contains('save')) {
      return 'increase_savings';
    }
    if (lower.contains('emergency fund')) return 'build_emergency_fund';
    if (lower.contains('expense')) return 'reduce_expenses';
    if (lower.contains('tax')) return 'optimize_taxes';
    if (lower.contains('goal')) return 'adjust_goals';
    if (lower.contains('review')) return 'review_required';

    return 'general_recommendation';
  }
}
