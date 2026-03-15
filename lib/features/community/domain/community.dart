// Community domain models

enum PostCategory {
  general,
  budgeting,
  investing,
  saving,
  debt,
  taxes,
}

enum ChallengeType {
  savings,
  noSpend,
  debtPayoff,
  budgetStreak,
}

class CommunityPost {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final String? title;
  final PostCategory category;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isAnonymous;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    this.title,
    required this.category,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isAnonymous = false,
  });
}

class FinancialBenchmark {
  final String id;
  final String name;
  final double value;
  final String category;
  final String description;
  final double userValue;
  final double communityAverage;
  final double percentile;
  final String insight;

  FinancialBenchmark({
    required this.id,
    required this.name,
    required this.value,
    required this.category,
    required this.description,
    required this.userValue,
    required this.communityAverage,
    required this.percentile,
    required this.insight,
  });
}

class Challenge {
  final String id;
  final String name;
  final String title;
  final ChallengeType type;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int participants;
  final bool isJoined;
  final double? targetAmount;
  final double? currentProgress;

  Challenge({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.participants = 0,
    String? title,
    this.isJoined = false,
    this.targetAmount,
    this.currentProgress,
  }) : title = title ?? name;

  int get durationDays => endDate.difference(startDate).inDays;
}
