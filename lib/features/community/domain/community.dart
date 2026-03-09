import 'package:hive/hive.dart';

part 'community.g.dart';

@HiveType(typeId: 47)
class CommunityPost extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String authorName;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final PostCategory category;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final int likes;

  @HiveField(7)
  final int comments;

  @HiveField(8)
  final bool isAnonymous;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isAnonymous = false,
  });
}

@HiveType(typeId: 48)
enum PostCategory {
  @HiveField(0)
  budgeting,
  @HiveField(1)
  investing,
  @HiveField(2)
  taxes,
  @HiveField(3)
  debt,
  @HiveField(4)
  savings,
  @HiveField(5)
  general,
}

@HiveType(typeId: 49)
class FinancialBenchmark extends HiveObject {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double userValue;

  @HiveField(2)
  final double communityAverage;

  @HiveField(3)
  final double percentile;

  @HiveField(4)
  final String insight;

  FinancialBenchmark({
    required this.category,
    required this.userValue,
    required this.communityAverage,
    required this.percentile,
    required this.insight,
  });
}

@HiveType(typeId: 50)
class Challenge extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final ChallengeType type;

  @HiveField(4)
  final double targetAmount;

  @HiveField(5)
  final int durationDays;

  @HiveField(6)
  final DateTime startDate;

  @HiveField(7)
  final int participants;

  @HiveField(8)
  final bool isJoined;

  @HiveField(9)
  final double currentProgress;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetAmount,
    required this.durationDays,
    required this.startDate,
    this.participants = 0,
    this.isJoined = false,
    this.currentProgress = 0.0,
  });
}

@HiveType(typeId: 51)
enum ChallengeType {
  @HiveField(0)
  savings,
  @HiveField(1)
  noSpend,
  @HiveField(2)
  debtPayoff,
  @HiveField(3)
  budgetStreak,
}
