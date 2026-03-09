import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/financial_context.dart';
import '../domain/agent_result.dart';
import '../domain/financial_decision.dart';
import 'agent_orchestrator.dart';
import 'decision_arbiter.dart';
import 'financial_brain.dart';
import 'autonomous_executor.dart';
import 'investment_executor.dart';
import 'negotiation_engine.dart';
import 'milestone_planner.dart';
import 'retirement_engine.dart';
import 'consciousness_layer.dart';
import 'financial_decision_scheduler.dart';

final financialLifeOSProvider = Provider((ref) => FinancialLifeOS(
      orchestrator: ref.read(agentOrchestratorProvider),
      arbiter: ref.read(decisionArbiterProvider),
      brain: ref.read(financialBrainProvider),
      executor: ref.read(autonomousExecutorProvider),
      investmentExecutor: ref.read(investmentExecutorProvider),
      negotiationEngine: ref.read(negotiationEngineProvider),
      milestonePlanner: ref.read(milestonePlannerProvider),
      retirementEngine: ref.read(retirementEngineProvider),
      consciousness: ref.read(consciousnessLayerProvider),
      scheduler: ref.read(financialDecisionSchedulerProvider),
    ));

/// Financial Life OS
/// Master orchestrator for the complete AI financial operating system
/// 
/// Coordinates 60+ systems to provide:
/// - Multi-agent intelligence
/// - Autonomous decision execution
/// - Investment management
/// - Bill negotiation
/// - Milestone planning
/// - Retirement intelligence
/// - Complete explainability
class FinancialLifeOS {
  final AgentOrchestrator orchestrator;
  final DecisionArbiter arbiter;
  final FinancialBrain brain;
  final AutonomousExecutor executor;
  final InvestmentExecutor investmentExecutor;
  final NegotiationEngine negotiationEngine;
  final MilestonePlanner milestonePlanner;
  final RetirementEngine retirementEngine;
  final ConsciousnessLayer consciousness;
  final FinancialDecisionScheduler scheduler;

  FinancialLifeOS({
    required this.orchestrator,
    required this.arbiter,
    required this.brain,
    required this.executor,
    required this.investmentExecutor,
    required this.negotiationEngine,
    required this.milestonePlanner,
    required this.retirementEngine,
    required this.consciousness,
    required this.scheduler,
  });

  /// Run complete financial intelligence cycle
  Future<FinancialLifeOSResult> runIntelligenceCycle(
    FinancialContext context,
  ) async {
    safePrint('');
    safePrint('═══════════════════════════════════════════════════════');
    safePrint('🌟 FINANCIAL LIFE OS - Intelligence Cycle Starting');
    safePrint('═══════════════════════════════════════════════════════');
    safePrint('');

    final startTime = DateTime.now();

    try {
      // 1. Multi-Agent Analysis
      safePrint('📊 Phase 1: Multi-Agent Analysis');
      final agentResults = await orchestrator.runAll(context);
      safePrint('   ✅ ${agentResults.length} agents completed analysis');
      safePrint('');

      // 2. Decision Arbitration
      safePrint('⚖️  Phase 2: Decision Arbitration');
      final decisions = arbiter.arbitrate(agentResults);
      safePrint('   ✅ ${decisions.length} decisions synthesized');
      safePrint('');

      // 3. Brain Evaluation
      safePrint('🧠 Phase 3: Financial Brain Evaluation');
      final brainState = await brain.evaluate(context.profile);
      safePrint('   ✅ Health score: ${brainState.healthScore}/100');
      safePrint('');

      // 4. Autonomous Execution
      safePrint('🤖 Phase 4: Autonomous Execution');
      final executionResults = await executor.executeBatch(decisions);
      final executed = executionResults.where((r) => r.executed).length;
      final requiresApproval = executionResults.where((r) => r.requiresApproval).length;
      safePrint('   ✅ $executed actions executed automatically');
      safePrint('   ⚠️  $requiresApproval actions require approval');
      safePrint('');

      // 5. Generate Insights
      safePrint('💡 Phase 5: Generating Insights');
      final insights = arbiter.synthesizeInsights(agentResults);
      safePrint('   ✅ Insights synthesized from ${insights['agentCount']} agents');
      safePrint('');

      // 6. Explainability
      safePrint('🔍 Phase 6: Consciousness Layer');
      final explanations = decisions.map((d) {
        return consciousness.explainDecision(d, agentResults);
      }).toList();
      safePrint('   ✅ ${explanations.length} decisions explained');
      safePrint('');

      final duration = DateTime.now().difference(startTime);
      
      safePrint('═══════════════════════════════════════════════════════');
      safePrint('✨ Intelligence Cycle Complete in ${duration.inMilliseconds}ms');
      safePrint('═══════════════════════════════════════════════════════');
      safePrint('');

      return FinancialLifeOSResult(
        agentResults: agentResults,
        decisions: decisions,
        brainState: brainState,
        executionResults: executionResults,
        insights: insights,
        explanations: explanations,
        duration: duration,
      );
    } catch (e) {
      safePrint('❌ Intelligence cycle failed: $e');
      rethrow;
    }
  }

  /// Quick health check (lightweight)
  Future<Map<String, dynamic>> quickHealthCheck(FinancialContext context) async {
    safePrint('[FinancialLifeOS] Running quick health check...');

    final healthCheck = await brain.quickCheck(context.profile);
    final agentResults = await orchestrator.runHighPriority(context);

    return {
      'healthScore': healthCheck['healthScore'],
      'healthStatus': healthCheck['healthStatus'],
      'urgentActions': healthCheck['urgentActionCount'],
      'highPriorityAgents': agentResults.length,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Answer user question
  Future<String> answerQuestion(
    String question,
    FinancialContext context,
  ) async {
    safePrint('[FinancialLifeOS] Answering: $question');
    return await consciousness.answerUserQuery(question, context);
  }

  /// Explain why a decision was made
  Future<String> explainWhy(
    FinancialDecision decision,
    FinancialContext context,
  ) async {
    return await consciousness.explainWhy(decision, context);
  }

  /// Simulate "what if" scenario
  Future<String> simulateWhatIf(
    String scenario,
    FinancialContext context,
  ) async {
    return await consciousness.explainWhatIf(scenario, context);
  }

  /// Get system status
  Map<String, dynamic> getSystemStatus() {
    return {
      'version': '1.0.0',
      'systems': {
        'agents': orchestrator.agentCount,
        'brain': 'operational',
        'executor': 'operational',
        'investment': 'operational',
        'negotiation': 'operational',
        'milestones': 'operational',
        'retirement': 'operational',
        'consciousness': 'operational',
      },
      'capabilities': [
        'Multi-agent intelligence',
        'Autonomous execution',
        'Investment management',
        'Bill negotiation',
        'Milestone planning',
        'Retirement simulation',
        'Complete explainability',
      ],
      'status': 'operational',
    };
  }

  /// Generate executive summary
  Future<String> generateExecutiveSummary(
    FinancialLifeOSResult result,
  ) async {
    final summary = StringBuffer();

    summary.writeln('🌟 FINANCIAL LIFE OS - Executive Summary\n');

    // Health
    summary.writeln('📊 Financial Health: ${result.brainState.healthScore}/100');
    
    // Agents
    summary.writeln('🤖 Agent Analysis: ${result.agentResults.length} specialized agents');
    final avgConfidence = result.agentResults
        .map((a) => a.confidence)
        .reduce((a, b) => a + b) / result.agentResults.length;
    summary.writeln('   Average confidence: ${(avgConfidence * 100).toStringAsFixed(0)}%');

    // Decisions
    summary.writeln('\n🎯 Decisions: ${result.decisions.length} recommendations');
    final urgent = result.decisions.where((d) => d.priority >= 8).length;
    if (urgent > 0) {
      summary.writeln('   ⚠️  $urgent urgent actions');
    }

    // Execution
    final executed = result.executionResults.where((r) => r.executed).length;
    summary.writeln('\n✅ Execution: $executed actions completed automatically');

    // Performance
    summary.writeln('\n⚡ Performance: ${result.duration.inMilliseconds}ms');

    return summary.toString();
  }
}

/// Financial Life OS Result
class FinancialLifeOSResult {
  final List<AgentResult> agentResults;
  final List<FinancialDecision> decisions;
  final dynamic brainState;
  final List<dynamic> executionResults;
  final Map<String, dynamic> insights;
  final List<Map<String, dynamic>> explanations;
  final Duration duration;

  FinancialLifeOSResult({
    required this.agentResults,
    required this.decisions,
    required this.brainState,
    required this.executionResults,
    required this.insights,
    required this.explanations,
    required this.duration,
  });

  /// Get urgent decisions
  List<FinancialDecision> get urgentDecisions {
    return decisions.where((d) => d.priority >= 8).toList();
  }

  /// Get executed actions
  List<dynamic> get executedActions {
    return executionResults.where((r) => r.executed).toList();
  }

  /// Get actions requiring approval
  List<dynamic> get actionsRequiringApproval {
    return executionResults.where((r) => r.requiresApproval).toList();
  }

  /// Success rate
  double get successRate {
    if (executionResults.isEmpty) return 1.0;
    final successful = executionResults.where((r) => r.executed).length;
    return successful / executionResults.length;
  }
}
