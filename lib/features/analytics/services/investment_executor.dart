import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/portfolio.dart';
import '../../../core/services/ai_audit_logger.dart';

final investmentExecutorProvider = Provider((ref) => InvestmentExecutor(
      auditLogger: ref.read(aiAuditLoggerProvider),
    ));

/// Investment Executor
/// Automatically manages investments within safe risk boundaries
class InvestmentExecutor {
  final AIAuditLogger auditLogger;

  InvestmentExecutor({required this.auditLogger});

  /// Execute portfolio adjustment
  Future<List<RebalancingAction>> executePortfolioAdjustment({
    required Portfolio current,
    required double riskTolerance,
    required double totalValue,
  }) async {
    safePrint('[InvestmentExecutor] Starting portfolio adjustment...');
    safePrint('[InvestmentExecutor] Total value: \$$totalValue');
    safePrint('[InvestmentExecutor] Risk tolerance: $riskTolerance');

    // 1. Get target allocation
    final target = PortfolioAllocation.forRiskTolerance(riskTolerance);
    safePrint('[InvestmentExecutor] Target: ${target.toMap()}');

    // 2. Calculate rebalancing actions
    final actions = _calculateRebalancing(current, target, totalValue);
    safePrint('[InvestmentExecutor] Generated ${actions.length} actions');

    // 3. Simulate before execution
    final simulation = _simulateActions(current, actions);
    safePrint('[InvestmentExecutor] Simulation: ${simulation['valid']}');

    // 4. Check compliance
    if (!_checkCompliance(actions, totalValue)) {
      safePrint('[InvestmentExecutor] ❌ Compliance check failed');
      await _auditFailure('Compliance check failed');
      return [];
    }

    // 5. Execute within limits (in production, would place actual orders)
    final executed = <RebalancingAction>[];
    for (final action in actions) {
      if (_withinLimits(action, totalValue)) {
        // TODO: Place actual order via brokerage API
        safePrint('[InvestmentExecutor] ✅ Would execute: ${action.action} ${action.shares} ${action.symbol}');
        executed.add(action);
        await _auditAction(action);
      } else {
        safePrint('[InvestmentExecutor] ⚠️ Skipped (exceeds limits): ${action.symbol}');
      }
    }

    safePrint('[InvestmentExecutor] Complete: ${executed.length} actions executed');
    return executed;
  }

  /// Calculate rebalancing actions
  List<RebalancingAction> _calculateRebalancing(
    Portfolio current,
    PortfolioAllocation target,
    double totalValue,
  ) {
    final actions = <RebalancingAction>[];
    final currentAllocation = current.getCurrentAllocation();

    // Calculate differences
    final stocksDiff = (target.stocks - currentAllocation.stocks) * totalValue;
    final bondsDiff = (target.bonds - currentAllocation.bonds) * totalValue;
    final cashDiff = (target.cash - currentAllocation.cash) * totalValue;

    // Generate actions (simplified - in production would be more sophisticated)
    if (stocksDiff.abs() > totalValue * 0.05) {
      // Only rebalance if difference > 5%
      actions.add(RebalancingAction(
        symbol: 'VTI', // Example: Vanguard Total Stock Market ETF
        action: stocksDiff > 0 ? 'buy' : 'sell',
        shares: stocksDiff.abs() / 200, // Assume $200/share
        estimatedValue: stocksDiff.abs(),
        reason: 'Rebalance stocks to target allocation',
      ));
    }

    if (bondsDiff.abs() > totalValue * 0.05) {
      actions.add(RebalancingAction(
        symbol: 'BND', // Example: Vanguard Total Bond Market ETF
        action: bondsDiff > 0 ? 'buy' : 'sell',
        shares: bondsDiff.abs() / 80, // Assume $80/share
        estimatedValue: bondsDiff.abs(),
        reason: 'Rebalance bonds to target allocation',
      ));
    }

    return actions;
  }

  /// Simulate actions
  Map<String, dynamic> _simulateActions(
    Portfolio current,
    List<RebalancingAction> actions,
  ) {
    // Simulate the portfolio after actions
    double projectedValue = current.totalValue;

    for (final action in actions) {
      if (action.action == 'buy') {
        projectedValue += action.estimatedValue;
      } else {
        projectedValue -= action.estimatedValue;
      }
    }

    return {
      'valid': true,
      'projectedValue': projectedValue,
      'valueChange': projectedValue - current.totalValue,
    };
  }

  /// Check compliance
  bool _checkCompliance(List<RebalancingAction> actions, double totalValue) {
    // Compliance rules:
    // 1. No single trade > 20% of portfolio
    // 2. Total rebalancing < 50% of portfolio
    // 3. No more than 5 trades at once

    if (actions.length > 5) return false;

    double totalRebalancing = 0;
    for (final action in actions) {
      if (action.estimatedValue > totalValue * 0.2) return false;
      totalRebalancing += action.estimatedValue;
    }

    if (totalRebalancing > totalValue * 0.5) return false;

    return true;
  }

  /// Check if action is within limits
  bool _withinLimits(RebalancingAction action, double totalValue) {
    // Safety limits:
    // - No trade > $10,000
    // - No trade > 15% of portfolio
    if (action.estimatedValue > 10000) return false;
    if (action.estimatedValue > totalValue * 0.15) return false;
    return true;
  }

  Future<void> _auditAction(RebalancingAction action) async {
    await auditLogger.logDecision(
      action: 'investment_execution',
      model: 'investment_executor',
      inputSummary: '${action.action} ${action.shares} ${action.symbol}',
      outputSummary: 'Executed: \$${action.estimatedValue}',
      tokensUsed: 0,
      cost: 0.0,
      success: true,
    );
  }

  Future<void> _auditFailure(String reason) async {
    await auditLogger.logDecision(
      action: 'investment_execution_failed',
      model: 'investment_executor',
      inputSummary: 'Portfolio rebalancing',
      outputSummary: 'Failed: $reason',
      tokensUsed: 0,
      cost: 0.0,
      success: false,
    );
  }
}

/// Portfolio Allocator
/// Recommends target allocation based on risk tolerance
class PortfolioAllocator {
  PortfolioAllocation recommend(double riskTolerance) {
    return PortfolioAllocation.forRiskTolerance(riskTolerance);
  }
}

/// Portfolio Rebalancer
/// Calculates rebalancing actions
class PortfolioRebalancer {
  List<RebalancingAction> rebalance(
    Portfolio current,
    PortfolioAllocation target,
    double totalValue,
  ) {
    // Implemented in InvestmentExecutor._calculateRebalancing
    return [];
  }
}
