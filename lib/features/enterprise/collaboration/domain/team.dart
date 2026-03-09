import 'package:hive/hive.dart';

part 'team.g.dart';

@HiveType(typeId: 36)
class Team extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessEntityId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final List<String> memberIds;

  @HiveField(5)
  final DateTime createdAt;

  Team({
    required this.id,
    required this.businessEntityId,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.createdAt,
  });

  int get memberCount => memberIds.length;

  Team copyWith({
    String? id,
    String? businessEntityId,
    String? name,
    String? description,
    List<String>? memberIds,
    DateTime? createdAt,
  }) {
    return Team(
      id: id ?? this.id,
      businessEntityId: businessEntityId ?? this.businessEntityId,
      name: name ?? this.name,
      description: description ?? this.description,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 37)
class TeamMember extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String teamId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final TeamRole role;

  @HiveField(5)
  final DateTime joinedAt;

  TeamMember({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.name,
    required this.role,
    required this.joinedAt,
  });
}

@HiveType(typeId: 38)
enum TeamRole {
  @HiveField(0)
  owner,

  @HiveField(1)
  admin,

  @HiveField(2)
  member,

  @HiveField(3)
  viewer,
}
