import 'package:hive/hive.dart';

// part 'family_account.g.dart';

@HiveType(typeId: 28)
class FamilyAccount extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String createdBy;

  @HiveField(3)
  final List<String> memberIds;

  @HiveField(4)
  final DateTime createdAt;

  FamilyAccount({
    required this.id,
    required this.name,
    String? createdBy,
    List<String>? memberIds,
    DateTime? createdAt,
  }) : createdBy = createdBy ?? 'current_user',
       memberIds = memberIds ?? [],
       createdAt = createdAt ?? DateTime.now();

  FamilyAccount copyWith({
    String? id,
    String? name,
    String? createdBy,
    List<String>? memberIds,
    DateTime? createdAt,
  }) {
    return FamilyAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 29)
class FamilyMember extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String familyAccountId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final FamilyRole role;

  @HiveField(5)
  final double? allowance;

  FamilyMember({
    required this.id,
    required this.familyAccountId,
    String? userId,
    required this.name,
    required this.role,
    this.allowance,
  }) : userId = userId ?? 'user_${id.substring(0, 8)}';
}

@HiveType(typeId: 30)
enum FamilyRole {
  @HiveField(0)
  owner,

  @HiveField(1)
  admin,

  @HiveField(2)
  parent,

  @HiveField(3)
  member,

  @HiveField(4)
  child,

  @HiveField(5)
  viewer,
}
