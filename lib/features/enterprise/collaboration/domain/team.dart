// Team domain models

enum TeamRole {
  owner,
  admin,
  member,
  viewer,
}

class Team {
  final String id;
  final String name;
  final String ownerId;
  final DateTime createdAt;
  final String description;
  final List<TeamMember> members;

  Team({
    required this.id,
    required this.name,
    String? ownerId,
    required this.createdAt,
    this.description = '',
    this.members = const [],
  }) : ownerId = ownerId ?? 'current_user';
}

class TeamMember {
  final String id;
  final String name;
  final String email;
  final TeamRole role;
  final DateTime joinedAt;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedAt,
  });
}
