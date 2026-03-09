import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/financial_context.dart';
import '../domain/agent_result.dart';
import 'financial_agent.dart';

final agentOrchestratorProvider = Provider((ref) => AgentOrchestrator());

/// Agent Orchestrator
/// Coordinates multiple specialized financial agents
class AgentOrchestrator {
  final List<FinancialAgent> _agents = [
    HealthAgent(),
    RiskAgent(),
    TaxAgent(),
    GoalAgent(),
    CashflowAgent(),
  ];

  /// Run all agents in parallel
  Future<List<AgentResult>> runAll(FinancialContext context) async {
    safePrint('[AgentOrchestrator] Running ${_agents.length} agents...');

    final results = <AgentResult>[];

    for (final agent in _agents) {
      if (agent.shouldRun(context)) {
        try {
          final result = await agent.analyze(context);
          results.add(result);
          safePrint('[AgentOrchestrator] ✅ ${agent.name}: ${result.confidence}');
        } catch (e) {
          safePrint('[AgentOrchestrator] ❌ ${agent.name} failed: $e');
        }
      }
    }

    safePrint('[AgentOrchestrator] Complete: ${results.length} results');
    return results;
  }

  /// Run specific agent types
  Future<List<AgentResult>> runByType(
    FinancialContext context,
    List<String> types,
  ) async {
    final filtered = _agents.where((a) => types.contains(a.type)).toList();
    
    final results = <AgentResult>[];
    for (final agent in filtered) {
      if (agent.shouldRun(context)) {
        final result = await agent.analyze(context);
        results.add(result);
      }
    }

    return results;
  }

  /// Run high-priority agents only
  Future<List<AgentResult>> runHighPriority(
    FinancialContext context, {
    int minPriority = 8,
  }) async {
    final filtered = _agents.where((a) => a.priority >= minPriority).toList();
    
    final results = <AgentResult>[];
    for (final agent in filtered) {
      if (agent.shouldRun(context)) {
        final result = await agent.analyze(context);
        results.add(result);
      }
    }

    return results;
  }

  /// Get agent by type
  FinancialAgent? getAgent(String type) {
    try {
      return _agents.firstWhere((a) => a.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Get all agent types
  List<String> getAgentTypes() {
    return _agents.map((a) => a.type).toList();
  }

  /// Get agent count
  int get agentCount => _agents.length;
}
