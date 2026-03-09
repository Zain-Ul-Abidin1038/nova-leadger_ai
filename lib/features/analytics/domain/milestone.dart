/// Life Milestone
class LifeMilestone {
  final String id;
  final String name;
  final String type; // 'home', 'wedding', 'education', 'business', 'vehicle', etc.
  final double estimatedCost;
  final DateTime targetDate;
  final int priority; // 1-10
  final Map<String, dynamic> metadata;

  LifeMilestone({
    required this.id,
    required this.name,
    required this.type,
    required this.estimatedCost,
    required this.targetDate,
    required this.priority,
    this.metadata = const {},
  });

  /// Months until milestone
  int get monthsUntil {
    final now = DateTime.now();
    final diff = targetDate.difference(now);
    return (diff.inDays / 30).ceil();
  }

  /// Is urgent (< 6 months)
  bool get isUrgent => monthsUntil <= 6;

  /// Is high priority
  bool get isHighPriority => priority >= 8;
}

/// Milestone Timeline
class MilestoneTimeline {
  final LifeMilestone milestone;
  final DateTime startDate;
  final DateTime targetDate;
  final List<MilestoneCheckpoint> checkpoints;

  MilestoneTimeline({
    required this.milestone,
    required this.startDate,
    required this.targetDate,
    required this.checkpoints,
  });

  /// Progress percentage
  double get progress {
    final now = DateTime.now();
    final total = targetDate.difference(startDate).inDays;
    final elapsed = now.difference(startDate).inDays;
    return (elapsed / total).clamp(0.0, 1.0);
  }
}

/// Milestone Checkpoint
class MilestoneCheckpoint {
  final DateTime date;
  final double targetAmount;
  final String description;

  MilestoneCheckpoint({
    required this.date,
    required this.targetAmount,
    required this.description,
  });
}

/// Milestone Plan
class MilestonePlan {
  final List<LifeMilestone> milestones;
  final Map<String, MilestoneTimeline> timelines;
  final Map<String, double> monthlyAllocation;
  final List<String> actions;
  final Map<String, dynamic> tradeoffs;

  MilestonePlan({
    required this.milestones,
    required this.timelines,
    required this.monthlyAllocation,
    required this.actions,
    this.tradeoffs = const {},
  });

  /// Total monthly allocation
  double get totalMonthlyAllocation {
    return monthlyAllocation.values.fold(0.0, (sum, amount) => sum + amount);
  }

  /// Is feasible
  bool isFeasible(double availableMonthly) {
    return totalMonthlyAllocation <= availableMonthly;
  }
}
