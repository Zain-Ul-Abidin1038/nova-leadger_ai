import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/user_financial_profile.dart';
import 'financial_brain.dart';
import 'decision_synthesizer.dart';
import 'decision_dispatcher.dart';

final financialDecisionSchedulerProvider = Provider((ref) => FinancialDecisionScheduler(
      brain: ref.read(financialBrainProvider),
      synthesizer: ref.read(decisionSynthesizerProvider),
      dispatcher: ref.read(decisionDispatcherProvider),
    ));

/// Financial Decision Scheduler
/// Orchestrates the continuous intelligence loop
/// 
/// Flow:
/// 1. Evaluate financial state (FinancialBrain)
/// 2. Synthesize decisions (DecisionSynthesizer)
/// 3. Dispatch decisions (DecisionDispatcher)
/// 4. Learn from user actions (FinancialLearningMemory)
class FinancialDecisionScheduler {
  final FinancialBrain brain;
  final DecisionSynthesizer synthesizer;
  final DecisionDispatcher dispatcher;

  FinancialDecisionScheduler({
    required this.brain,
    required this.synthesizer,
    required this.dispatcher,
  });

  /// Run full intelligence cycle
  Future<void> run(UserFinancialProfile profile) async {
    safePrint('[DecisionScheduler] Starting intelligence cycle...');

    try {
      // Step 1: Evaluate financial state
      safePrint('[DecisionScheduler] Step 1: Evaluating financial state...');
      final state = await brain.evaluate(profile);
      safePrint('[DecisionScheduler] Health Score: ${state.healthScore.toInt()}/100');

      // Step 2: Synthesize decisions
      safePrint('[DecisionScheduler] Step 2: Synthesizing decisions...');
      final decisions = synthesizer.synthesize(state);
      safePrint('[DecisionScheduler] Generated ${decisions.length} decisions');

      // Step 3: Dispatch decisions
      safePrint('[DecisionScheduler] Step 3: Dispatching decisions...');
      await dispatcher.dispatchBatch(decisions);

      // Step 4: Log completion
      safePrint('[DecisionScheduler] ✅ Intelligence cycle complete');
      safePrint('[DecisionScheduler] High priority: ${decisions.where((d) => d.priority >= 8).length}');
      safePrint('[DecisionScheduler] Medium priority: ${decisions.where((d) => d.priority >= 5 && d.priority < 8).length}');
      safePrint('[DecisionScheduler] Low priority: ${decisions.where((d) => d.priority < 5).length}');
    } catch (e) {
      safePrint('[DecisionScheduler] ❌ Error: $e');
      rethrow;
    }
  }

  /// Run quick check (lightweight evaluation)
  Future<Map<String, dynamic>> quickCheck(UserFinancialProfile profile) async {
    safePrint('[DecisionScheduler] Running quick check...');

    try {
      final quickState = await brain.quickCheck(profile);
      
      return {
        'success': true,
        'healthScore': quickState['healthScore'],
        'urgentActions': quickState['urgentActions'],
        'cashflowStatus': quickState['cashflowStatus'],
      };
    } catch (e) {
      safePrint('[DecisionScheduler] Quick check error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Schedule periodic runs (call from background task)
  Future<void> schedulePeriodicRuns() async {
    // TODO: Integrate with background task scheduler
    // For now, just log
    safePrint('[DecisionScheduler] Periodic runs would be scheduled here');
    
    // In production, use:
    // - workmanager package for Android
    // - background_fetch for iOS
    // - Run every 6-12 hours
  }
}
