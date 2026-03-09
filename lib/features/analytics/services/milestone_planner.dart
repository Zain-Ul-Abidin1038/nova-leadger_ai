import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/milestone.dart';
import '../domain/financial_context.dart';

final milestonePlannerProvider = Provider((ref) => MilestonePlanner());

/// Life Milestone Planner
/// Plans financial actions around major life events
class MilestonePlanner {
  /// Plan milestones
  Future<MilestonePlan> planMilestones(
    EconomicDigitalTwin twin,
    List<LifeMilestone> milestones,
  ) async {
    safePrint('[MilestonePlanner] Planning ${milestones.length} milestones...');

    // 1. Prioritize milestones
    final prioritized = _prioritizeMilestones(milestones);
    safePrint('[MilestonePlanner] Prioritized by urgency and importance');

    // 2. Calculate requirements
    final requirements = _calculateRequirements(prioritized);
    safePrint('[MilestonePlanner] Total required: \$${requirements['total']}');

    // 3. Generate timelines
    final timelines = _generateTimelines(prioritized);
    safePrint('[MilestonePlanner] Generated ${timelines.length} timelines');

    // 4. Optimize allocation
    final allocation = _optimizeAllocation(twin, prioritized);
    safePrint('[MilestonePlanner] Monthly allocation: \$${allocation.values.fold(0.0, (sum, v) => sum + v)}');

    // 5. Create action plan
    final actions = _createActionPlan(allocation, twin);
    safePrint('[MilestonePlanner] Generated ${actions.length} actions');

    // 6. Identify tradeoffs
    final tradeoffs = _identifyTradeoffs(allocation, twin);

    return MilestonePlan(
      milestones: prioritized,
      timelines: timelines,
      monthlyAllocation: allocation,
      actions: actions,
      tradeoffs: tradeoffs,
    );
  }

  /// Prioritize milestones
  List<LifeMilestone> _prioritizeMilestones(List<LifeMilestone> milestones) {
    final sorted = List<LifeMilestone>.from(milestones);

    // Sort by: 1) urgency, 2) priority, 3) cost
    sorted.sort((a, b) {
      // First by urgency
      if (a.isUrgent && !b.isUrgent) return -1;
      if (!a.isUrgent && b.isUrgent) return 1;

      // Then by priority
      final priorityDiff = b.priority.compareTo(a.priority);
      if (priorityDiff != 0) return priorityDiff;

      // Finally by months until (sooner first)
      return a.monthsUntil.compareTo(b.monthsUntil);
    });

    return sorted;
  }

  /// Calculate requirements
  Map<String, dynamic> _calculateRequirements(List<LifeMilestone> milestones) {
    double total = 0;
    final breakdown = <String, double>{};

    for (final milestone in milestones) {
      total += milestone.estimatedCost;
      breakdown[milestone.id] = milestone.estimatedCost;
    }

    return {
      'total': total,
      'breakdown': breakdown,
    };
  }

  /// Generate timelines
  Map<String, MilestoneTimeline> _generateTimelines(
    List<LifeMilestone> milestones,
  ) {
    final timelines = <String, MilestoneTimeline>{};

    for (final milestone in milestones) {
      final startDate = DateTime.now();
      final checkpoints = _generateCheckpoints(
        milestone,
        startDate,
        milestone.targetDate,
      );

      timelines[milestone.id] = MilestoneTimeline(
        milestone: milestone,
        startDate: startDate,
        targetDate: milestone.targetDate,
        checkpoints: checkpoints,
      );
    }

    return timelines;
  }

  /// Generate checkpoints
  List<MilestoneCheckpoint> _generateCheckpoints(
    LifeMilestone milestone,
    DateTime start,
    DateTime end,
  ) {
    final checkpoints = <MilestoneCheckpoint>[];
    final months = milestone.monthsUntil;
    final monthlyTarget = milestone.estimatedCost / months;

    // Create quarterly checkpoints
    for (int i = 3; i <= months; i += 3) {
      final checkpointDate = start.add(Duration(days: i * 30));
      final targetAmount = monthlyTarget * i;

      checkpoints.add(MilestoneCheckpoint(
        date: checkpointDate,
        targetAmount: targetAmount,
        description: 'Checkpoint ${i ~/ 3}: \$${targetAmount.toStringAsFixed(0)} saved',
      ));
    }

    return checkpoints;
  }

  /// Optimize allocation
  Map<String, double> _optimizeAllocation(
    EconomicDigitalTwin twin,
    List<LifeMilestone> milestones,
  ) {
    final allocation = <String, double>{};
    final availableMonthly = twin.monthlyIncome - twin.monthlyExpenses;

    safePrint('[MilestonePlanner] Available monthly: \$$availableMonthly');

    // Allocate based on priority and urgency
    double totalAllocated = 0;

    for (final milestone in milestones) {
      final monthlyRequired = milestone.estimatedCost / milestone.monthsUntil;
      final weight = _calculateWeight(milestone);

      // Allocate proportionally, but cap at required amount
      double allocated = availableMonthly * weight;
      allocated = allocated.clamp(0, monthlyRequired);

      // Don't over-allocate
      if (totalAllocated + allocated > availableMonthly * 0.8) {
        // Reserve 20% for flexibility
        allocated = (availableMonthly * 0.8 - totalAllocated).clamp(0, allocated);
      }

      allocation[milestone.id] = allocated;
      totalAllocated += allocated;
    }

    return allocation;
  }

  /// Calculate milestone weight
  double _calculateWeight(LifeMilestone milestone) {
    double weight = 0.0;

    // Priority weight (40%)
    weight += (milestone.priority / 10) * 0.4;

    // Urgency weight (40%)
    final urgencyScore = milestone.isUrgent ? 1.0 : 0.5;
    weight += urgencyScore * 0.4;

    // Feasibility weight (20%)
    final feasibilityScore = milestone.monthsUntil >= 6 ? 1.0 : 0.5;
    weight += feasibilityScore * 0.2;

    return weight;
  }

  /// Create action plan
  List<String> _createActionPlan(
    Map<String, double> allocation,
    EconomicDigitalTwin twin,
  ) {
    final actions = <String>[];

    // Set up automatic transfers
    for (final entry in allocation.entries) {
      final milestoneId = entry.key;
      final amount = entry.value;

      if (amount > 0) {
        actions.add(
          'Set up automatic monthly transfer of \$${amount.toStringAsFixed(2)} for milestone $milestoneId',
        );
      }
    }

    // Adjust spending if needed
    final totalAllocation = allocation.values.fold(0.0, (sum, v) => sum + v);
    final available = twin.monthlyIncome - twin.monthlyExpenses;

    if (totalAllocation > available * 0.8) {
      actions.add('Review and reduce discretionary spending by \$${(totalAllocation - available * 0.8).toStringAsFixed(2)}');
    }

    // Increase income if needed
    if (totalAllocation > available) {
      actions.add('Consider additional income sources to meet milestone goals');
    }

    return actions;
  }

  /// Identify tradeoffs
  Map<String, dynamic> _identifyTradeoffs(
    Map<String, double> allocation,
    EconomicDigitalTwin twin,
  ) {
    final totalAllocation = allocation.values.fold(0.0, (sum, v) => sum + v);
    final available = twin.monthlyIncome - twin.monthlyExpenses;

    return {
      'totalRequired': totalAllocation,
      'available': available,
      'shortfall': (totalAllocation - available).clamp(0, double.infinity),
      'utilizationRate': available > 0 ? totalAllocation / available : 0,
      'needsAdjustment': totalAllocation > available * 0.8,
    };
  }

  /// Track progress
  Map<String, dynamic> trackProgress(
    LifeMilestone milestone,
    double currentSavings,
  ) {
    final progress = currentSavings / milestone.estimatedCost;
    final monthlyRequired = milestone.estimatedCost / milestone.monthsUntil;
    final onTrack = currentSavings >= (monthlyRequired * (DateTime.now().difference(DateTime.now().subtract(Duration(days: milestone.monthsUntil * 30))).inDays / 30));

    return {
      'progress': progress,
      'currentSavings': currentSavings,
      'targetAmount': milestone.estimatedCost,
      'onTrack': onTrack,
      'monthsRemaining': milestone.monthsUntil,
    };
  }
}
