import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/financial_decision.dart';
import 'action_safety_policy.dart';
import '../../../core/services/ai_audit_logger.dart';

final autonomousExecutorProvider = Provider((ref) => AutonomousExecutor(
      policy: ref.read(actionSafetyPolicyProvider),
      auditLogger: ref.read(aiAuditLoggerProvider),
    ));

/// Execution Result
class ExecutionResult {
  final bool executed;
  final bool requiresApproval;
  final FinancialDecision decision;
  final String? message;
  final Map<String, dynamic>? output;

  ExecutionResult.executed(this.decision, {this.output})
      : executed = true,
        requiresApproval = false,
        message = 'Action executed successfully';

  ExecutionResult.requiresApproval(this.decision)
      : executed = false,
        requiresApproval = true,
        message = 'Action requires user approval',
        output = null;

  ExecutionResult.failed(this.decision, String error)
      : executed = false,
        requiresApproval = false,
        message = 'Execution failed: $error',
        output = null;
}

/// Autonomous Executor
/// Auto-executes safe financial actions with audit trail
class AutonomousExecutor {
  final ActionSafetyPolicy policy;
  final AIAuditLogger auditLogger;

  AutonomousExecutor({
    required this.policy,
    required this.auditLogger,
  });

  /// Execute financial decision
  Future<ExecutionResult> execute(FinancialDecision decision) async {
    safePrint('[AutonomousExecutor] Evaluating: ${decision.type}');

    // Check safety policy
    if (!policy.isSafe(decision)) {
      safePrint('[AutonomousExecutor] ⚠️ Requires approval');
      await _auditRequiresApproval(decision);
      return ExecutionResult.requiresApproval(decision);
    }

    // Execute based on action type
    try {
      final output = await _executeAction(decision);
      
      await _auditSuccess(decision, output);
      
      safePrint('[AutonomousExecutor] ✅ Executed: ${decision.type}');
      return ExecutionResult.executed(decision, output: output);
    } catch (e) {
      safePrint('[AutonomousExecutor] ❌ Failed: $e');
      await _auditFailure(decision, e.toString());
      return ExecutionResult.failed(decision, e.toString());
    }
  }

  /// Execute batch of decisions
  Future<List<ExecutionResult>> executeBatch(
    List<FinancialDecision> decisions,
  ) async {
    final results = <ExecutionResult>[];
    
    for (final decision in decisions) {
      final result = await execute(decision);
      results.add(result);
    }

    final executed = results.where((r) => r.executed).length;
    final requiresApproval = results.where((r) => r.requiresApproval).length;
    
    safePrint('[AutonomousExecutor] Batch complete: $executed executed, $requiresApproval require approval');
    
    return results;
  }

  Future<Map<String, dynamic>> _executeAction(
    FinancialDecision decision,
  ) async {
    switch (decision.type) {
      case 'set_budget_limit':
        return await _setBudgetLimit(decision);
      
      case 'schedule_reminder':
        return await _scheduleReminder(decision);
      
      case 'flag_subscription':
        return await _flagSubscription(decision);
      
      case 'suggest_transfer_small':
        return await _suggestTransfer(decision);
      
      case 'adjust_category_budget':
        return await _adjustCategoryBudget(decision);
      
      case 'enable_savings_rule':
        return await _enableSavingsRule(decision);
      
      case 'set_spending_alert':
        return await _setSpendingAlert(decision);
      
      case 'update_goal_contribution':
        return await _updateGoalContribution(decision);
      
      default:
        throw Exception('Unknown action type: ${decision.type}');
    }
  }

  Future<Map<String, dynamic>> _setBudgetLimit(
    FinancialDecision decision,
  ) async {
    final category = decision.metadata['category'] as String;
    final limit = decision.metadata['amount'] as double;
    
    safePrint('[AutonomousExecutor] Setting budget limit: $category = ₹$limit');
    
    // TODO: Integrate with BudgetRepository
    // await BudgetRepository().setLimit(category, limit);
    
    return {
      'action': 'set_budget_limit',
      'category': category,
      'limit': limit,
      'status': 'executed',
    };
  }

  Future<Map<String, dynamic>> _scheduleReminder(
    FinancialDecision decision,
  ) async {
    final reminderType = decision.metadata['reminderType'] as String;
    final date = decision.metadata['date'] as String;
    
    safePrint('[AutonomousExecutor] Scheduling reminder: $reminderType on $date');
    
    // TODO: Integrate with notification system
    // await NotificationService().schedule(reminderType, date);
    
    return {
      'action': 'schedule_reminder',
      'type': reminderType,
      'date': date,
      'status': 'scheduled',
    };
  }

  Future<Map<String, dynamic>> _flagSubscription(
    FinancialDecision decision,
  ) async {
    final vendor = decision.metadata['vendor'] as String;
    final reason = decision.metadata['reason'] as String;
    
    safePrint('[AutonomousExecutor] Flagging subscription: $vendor - $reason');
    
    // TODO: Integrate with subscription tracker
    // await SubscriptionTracker().flag(vendor, reason);
    
    return {
      'action': 'flag_subscription',
      'vendor': vendor,
      'reason': reason,
      'status': 'flagged',
    };
  }

  Future<Map<String, dynamic>> _suggestTransfer(
    FinancialDecision decision,
  ) async {
    final amount = decision.metadata['amount'] as double;
    final toAccount = decision.metadata['toAccount'] as String;
    
    safePrint('[AutonomousExecutor] Suggesting transfer: ₹$amount to $toAccount');
    
    // Note: This only suggests, doesn't execute transfer
    return {
      'action': 'suggest_transfer',
      'amount': amount,
      'toAccount': toAccount,
      'status': 'suggested',
    };
  }

  Future<Map<String, dynamic>> _adjustCategoryBudget(
    FinancialDecision decision,
  ) async {
    final category = decision.metadata['category'] as String;
    final adjustment = decision.metadata['adjustment'] as double;
    
    safePrint('[AutonomousExecutor] Adjusting budget: $category by ₹$adjustment');
    
    // TODO: Integrate with BudgetAutopilot
    // await BudgetAutopilot().adjust(category, adjustment);
    
    return {
      'action': 'adjust_category_budget',
      'category': category,
      'adjustment': adjustment,
      'status': 'adjusted',
    };
  }

  Future<Map<String, dynamic>> _enableSavingsRule(
    FinancialDecision decision,
  ) async {
    final ruleType = decision.metadata['ruleType'] as String;
    final percentage = decision.metadata['percentage'] as double;
    
    safePrint('[AutonomousExecutor] Enabling savings rule: $ruleType at $percentage%');
    
    // TODO: Integrate with savings automation
    // await SavingsAutomation().enableRule(ruleType, percentage);
    
    return {
      'action': 'enable_savings_rule',
      'ruleType': ruleType,
      'percentage': percentage,
      'status': 'enabled',
    };
  }

  Future<Map<String, dynamic>> _setSpendingAlert(
    FinancialDecision decision,
  ) async {
    final category = decision.metadata['category'] as String;
    final threshold = decision.metadata['threshold'] as double;
    
    safePrint('[AutonomousExecutor] Setting spending alert: $category at ₹$threshold');
    
    // TODO: Integrate with alert system
    // await AlertSystem().setThreshold(category, threshold);
    
    return {
      'action': 'set_spending_alert',
      'category': category,
      'threshold': threshold,
      'status': 'set',
    };
  }

  Future<Map<String, dynamic>> _updateGoalContribution(
    FinancialDecision decision,
  ) async {
    final goalId = decision.metadata['goalId'] as String;
    final contribution = decision.metadata['contribution'] as double;
    
    safePrint('[AutonomousExecutor] Updating goal contribution: $goalId = ₹$contribution');
    
    // TODO: Integrate with GoalAutopilot
    // await GoalAutopilot().updateContribution(goalId, contribution);
    
    return {
      'action': 'update_goal_contribution',
      'goalId': goalId,
      'contribution': contribution,
      'status': 'updated',
    };
  }

  Future<void> _auditSuccess(
    FinancialDecision decision,
    Map<String, dynamic> output,
  ) async {
    await auditLogger.logDecision(
      action: 'autonomous_execution',
      model: 'autonomous_executor',
      inputSummary: '${decision.type}: ${decision.message}',
      outputSummary: 'Executed successfully',
      tokensUsed: 0,
      cost: 0.0,
      success: true,
    );
  }

  Future<void> _auditRequiresApproval(FinancialDecision decision) async {
    await auditLogger.logDecision(
      action: 'autonomous_execution_blocked',
      model: 'autonomous_executor',
      inputSummary: '${decision.type}: ${decision.message}',
      outputSummary: 'Requires user approval',
      tokensUsed: 0,
      cost: 0.0,
      success: true,
    );
  }

  Future<void> _auditFailure(FinancialDecision decision, String error) async {
    await auditLogger.logDecision(
      action: 'autonomous_execution_failed',
      model: 'autonomous_executor',
      inputSummary: '${decision.type}: ${decision.message}',
      outputSummary: 'Failed: $error',
      tokensUsed: 0,
      cost: 0.0,
      success: false,
    );
  }

  /// Get execution statistics
  Map<String, dynamic> getStatistics() {
    // TODO: Track execution stats
    return {
      'totalExecutions': 0,
      'successfulExecutions': 0,
      'failedExecutions': 0,
      'requiresApprovalCount': 0,
    };
  }
}
