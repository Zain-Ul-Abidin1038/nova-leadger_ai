import 'package:hive/hive.dart';

part 'api_key.g.dart';

@HiveType(typeId: 41)
class ApiKey extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessEntityId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String keyHash;

  @HiveField(4)
  final List<String> permissions;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? expiresAt;

  @HiveField(7)
  final bool isActive;

  ApiKey({
    required this.id,
    required this.businessEntityId,
    required this.name,
    required this.keyHash,
    required this.permissions,
    required this.createdAt,
    this.expiresAt,
    required this.isActive,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  ApiKey copyWith({
    String? id,
    String? businessEntityId,
    String? name,
    String? keyHash,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
  }) {
    return ApiKey(
      id: id ?? this.id,
      businessEntityId: businessEntityId ?? this.businessEntityId,
      name: name ?? this.name,
      keyHash: keyHash ?? this.keyHash,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
