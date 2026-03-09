import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/financial_goal.dart';
import '../domain/financial_snapshot.dart';

final goalAutopilotProvider = Provider((ref) => GoalAutopilot());

/// Goal Autopilot
/// Tracks goals and adjusts behavior automatically
class GoalAutopilot {
  static const String _boxName = 'financial_goals';
  Box<FinancialGoal>? _box;

  Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(FinancialGoalAdapter());
    }
    _box = await Hive.openBox<FinancialGoal>(_boxName);
  }

  /// Evaluate goals and generate actions
  List<GoalAction> evaluate(
    List<FinancialGoal> goals,
    FinancialSnapshot snapshot,
  ) {
    safePrint('[GoalAutopilot] Evaluating ${goals.length} goals');

    final actions = <GoalAction>[];

    for (final goal in goals) {
      if (goal.completed) continue;

      final progress = goal.progress;
      final daysRemaining = goal.daysRemaining;

      safePrint('[GoalAutopilot] ${goal.name}: ${(progress * 100).toStringAsFixed(0)}% complete, $daysRemaining days left');

      // Check if on track
      if (progress < 0.5 && daysRemaining < 180) {
        actions.add(GoalAction(
          goalId: goal.id,
          recommendation: 'Increase monthly contribution to ₹${goal.requiredMonthlyContribution.toStringAsFixed(0)}',
          suggestedContribution: goal.requiredMonthlyContribution,
          priority: 8,
        ));
      } else if (progress < 0.25) {
        actions.add(GoalAction(
          goalId: goal.id,
          recommendation: 'Goal at risk - consider adjusting target or timeline',
          suggestedContribution: goal.requiredMonthlyContribution * 1.5,
          priority: 9,
        ));
      } else if (progress >= 0.9) {
        actions.add(GoalAction(
          goalId: goal.id,
          recommendation: '🎉 Almost there! Just ₹${(goal.targetAmount - goal.currentAmount).toStringAsFixed(0)} to go',
          suggestedContribution: goal.requiredMonthlyContribution,
          priority: 5,
        ));
      }
    }

    return actions;
  }

  /// Add goal
  Future<void> addGoal(FinancialGoal goal) async {
    await _box?.put(goal.id, goal);
    safePrint('[GoalAutopilot] Added goal: ${goal.name}');
  }

  /// Update goal progress
  Future<void> updateProgress(String goalId, double amount) async {
    final goal = _box?.get(goalId);
    if (goal != null) {
      final updated = goal.copyWith(
        currentAmount: goal.currentAmount + amount,
        completed: (goal.currentAmount + amount) >= goal.targetAmount,
      );
      await _box?.put(goalId, updated);
    }
  }

  /// Get all goals
  List<FinancialGoal> getAllGoals() {
    return _box?.values.toList() ?? [];
  }

  /// Get active goals
  List<FinancialGoal> getActiveGoals() {
    return getAllGoals().where((g) => !g.completed).toList();
  }
}
