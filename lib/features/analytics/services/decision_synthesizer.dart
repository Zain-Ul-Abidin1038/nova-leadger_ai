import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/brain_state.dart';
import '../domain/financial_decision.dart';

final decisionSynthesizerProvider = Provider((ref) => DecisionSynthesizer());

/// Decision Synthesizer
/// Converts BrainState into actionable decisions with priorities
class DecisionSynthesizer {
  final _uuid = const Uuid();

  List<FinancialDecision> synthesize(BrainState state) {
    final decisions = <FinancialDecision>[];

    // 1. Health Score Decisions
    if (state.healthScore < 40) {
      decisions.add(_createDecision(
        type: DecisionType.riskWarning,
        message: '🚨 Critical: Your financial health score is ${state.healthScore.toInt()}/100. Immediate action needed.',
        priority: 10,
        metadata: {'healthScore': state.healthScore},
      ));
    } else if (state.healthScore < 60) {
      decisions.add(_createDecision(
        type: DecisionType.riskWarning,
        message: '⚠️ Warning: Financial health at ${state.healthScore.toInt()}/100. Review recommended actions.',
        priority: 7,
        metadata: {'healthScore': state.healthScore},
      ));
    }

    // 2. Coach Actions (Priority 1-3 = urgent)
    for (final action in state.coachActions) {
      if (action.priority <= 3 && !action.dismissed) {
        decisions.add(_createDecision(
          type: DecisionType.coachAction,
          message: '💡 ${action.title}: ${action.description}',
          priority: _mapCoachPriority(action.priority),
          metadata: {
            'actionId': action.id,
            'category': action.category,
          },
        ));
      }
    }

    // 3. Cashflow Predictions (Critical days)
    if (state.cashflowPrediction.criticalDay != null) {
      final daysUntil = state.cashflowPrediction.criticalDay!
          .difference(DateTime.now())
          .inDays;
      
      decisions.add(_createDecision(
        type: DecisionType.cashflowAlert,
        message: '💸 Alert: You may run out of cash in $daysUntil days. Current balance: ₹${state.cashflowPrediction.currentBalance.toStringAsFixed(0)}',
        priority: daysUntil < 7 ? 9 : 7,
        metadata: {
          'daysUntil': daysUntil,
          'criticalDay': state.cashflowPrediction.criticalDay!.toIso8601String(),
        },
      ));
    }

    // 4. Tax Optimization
    if (state.taxPlan.estimatedSavings > 1000) {
      decisions.add(_createDecision(
        type: DecisionType.taxOptimization,
        message: '💰 Tax Opportunity: You could save ₹${state.taxPlan.estimatedSavings.toStringAsFixed(0)} with better planning.',
        priority: 6,
        metadata: {
          'savings': state.taxPlan.estimatedSavings,
          'suggestions': state.taxPlan.suggestions.length,
        },
      ));
    }

    // 5. Anomalies
    for (final anomaly in state.anomalies) {
      decisions.add(_createDecision(
        type: DecisionType.anomalyDetected,
        message: '🔍 Unusual: ${anomaly.explanation}',
        priority: anomaly.severity == 'high' ? 8 : 5,
        metadata: {
          'anomalyType': anomaly.type,
          'severity': anomaly.severity,
        },
      ));
    }

    // 6. Budget Adjustments (from advanced analytics)
    // Will be added when budget autopilot runs

    // Sort by priority (highest first)
    decisions.sort((a, b) => b.priority.compareTo(a.priority));

    return decisions;
  }

  FinancialDecision _createDecision({
    required String type,
    required String message,
    required int priority,
    Map<String, dynamic> metadata = const {},
  }) {
    return FinancialDecision(
      id: _uuid.v4(),
      type: type,
      message: message,
      priority: priority,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  int _mapCoachPriority(int coachPriority) {
    // Coach priority 1-10 → Decision priority 1-10
    // Priority 1-3 = urgent (8-10)
    // Priority 4-6 = important (5-7)
    // Priority 7-10 = normal (1-4)
    if (coachPriority <= 3) return 10 - coachPriority + 7; // 8-10
    if (coachPriority <= 6) return 10 - coachPriority + 2; // 5-7
    return 10 - coachPriority; // 1-4
  }
}
