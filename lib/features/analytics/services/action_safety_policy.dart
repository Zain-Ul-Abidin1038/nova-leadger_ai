import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/financial_decision.dart';

final actionSafetyPolicyProvider = Provider((ref) => ActionSafetyPolicy());

/// Action Safety Policy
/// Determines which financial decisions can be auto-executed
/// 
/// Safety Rules:
/// 1. Only specific action types are auto-executable
/// 2. Priority must be medium or lower (< 8)
/// 3. Amount limits for financial actions
/// 4. No irreversible actions
class ActionSafetyPolicy {
  // Auto-executable action types
  static const Set<String> _safeActionTypes = {
    'set_budget_limit',
    'schedule_reminder',
    'flag_subscription',
    'suggest_transfer_small',
    'adjust_category_budget',
    'enable_savings_rule',
    'set_spending_alert',
    'update_goal_contribution',
  };

  // Maximum amounts for auto-execution
  static const double _maxAutoTransferAmount = 1000.0;
  static const double _maxBudgetAdjustment = 5000.0;

  /// Check if decision is safe for auto-execution
  bool isSafe(FinancialDecision decision) {
    safePrint('[SafetyPolicy] Evaluating: ${decision.type}');

    // Rule 1: Must be in safe action types
    if (!_safeActionTypes.contains(decision.type)) {
      safePrint('[SafetyPolicy] ❌ Action type not safe: ${decision.type}');
      return false;
    }

    // Rule 2: Priority must be < 8 (not urgent)
    if (decision.priority >= 8) {
      safePrint('[SafetyPolicy] ❌ Priority too high: ${decision.priority}');
      return false;
    }

    // Rule 3: Check amount limits
    if (!_checkAmountLimits(decision)) {
      safePrint('[SafetyPolicy] ❌ Amount exceeds limits');
      return false;
    }

    // Rule 4: Check for irreversible actions
    if (_isIrreversible(decision)) {
      safePrint('[SafetyPolicy] ❌ Action is irreversible');
      return false;
    }

    safePrint('[SafetyPolicy] ✅ Action is safe for auto-execution');
    return true;
  }

  bool _checkAmountLimits(FinancialDecision decision) {
    final amount = decision.metadata['amount'] as double?;
    if (amount == null) return true; // No amount = safe

    switch (decision.type) {
      case 'suggest_transfer_small':
        return amount <= _maxAutoTransferAmount;
      case 'set_budget_limit':
      case 'adjust_category_budget':
        return amount <= _maxBudgetAdjustment;
      default:
        return true;
    }
  }

  bool _isIrreversible(FinancialDecision decision) {
    // Actions that cannot be undone
    const irreversibleTypes = {
      'execute_payment',
      'delete_transaction',
      'close_account',
    };

    return irreversibleTypes.contains(decision.type);
  }

  /// Get safety level (0-1, higher = safer)
  double getSafetyLevel(FinancialDecision decision) {
    double safety = 1.0;

    // Reduce safety based on priority
    if (decision.priority >= 8) safety -= 0.5;
    if (decision.priority >= 6) safety -= 0.2;

    // Reduce safety based on amount
    final amount = decision.metadata['amount'] as double?;
    if (amount != null) {
      if (amount > _maxAutoTransferAmount) safety -= 0.3;
      if (amount > _maxBudgetAdjustment) safety -= 0.5;
    }

    // Reduce safety for non-safe types
    if (!_safeActionTypes.contains(decision.type)) safety -= 0.8;

    return safety.clamp(0.0, 1.0);
  }

  /// Get required approval level
  String getRequiredApprovalLevel(FinancialDecision decision) {
    if (isSafe(decision)) return 'none';
    if (decision.priority >= 8) return 'immediate';
    if (decision.priority >= 6) return 'standard';
    return 'optional';
  }
}
