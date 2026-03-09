import 'package:hive/hive.dart';

part 'tenant.g.dart';

@HiveType(typeId: 42)
class Tenant extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String domain;

  @HiveField(3)
  final BrandConfig branding;

  @HiveField(4)
  final List<String> enabledFeatures;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final bool isActive;

  Tenant({
    required this.id,
    required this.name,
    required this.domain,
    required this.branding,
    required this.enabledFeatures,
    required this.createdAt,
    required this.isActive,
  });

  Tenant copyWith({
    String? id,
    String? name,
    String? domain,
    BrandConfig? branding,
    List<String>? enabledFeatures,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Tenant(
      id: id ?? this.id,
      name: name ?? this.name,
      domain: domain ?? this.domain,
      branding: branding ?? this.branding,
      enabledFeatures: enabledFeatures ?? this.enabledFeatures,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

@HiveType(typeId: 43)
class BrandConfig extends HiveObject {
  @HiveField(0)
  final String logoUrl;

  @HiveField(1)
  final String primaryColor;

  @HiveField(2)
  final String secondaryColor;

  @HiveField(3)
  final String appName;

  @HiveField(4)
  final String tagline;

  BrandConfig({
    required this.logoUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.appName,
    required this.tagline,
  });
}
