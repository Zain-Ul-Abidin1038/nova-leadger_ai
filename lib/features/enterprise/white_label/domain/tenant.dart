// Tenant domain model

class Tenant {
  final String id;
  final String name;
  final String domain;
  final Map<String, dynamic> branding;
  final Map<String, bool> features;
  final bool isActive;
  final DateTime createdAt;
  final int userCount;

  Tenant({
    required this.id,
    required this.name,
    required this.domain,
    required this.branding,
    this.features = const {},
    this.isActive = true,
    required this.createdAt,
    this.userCount = 0,
  });
}

class BrandConfig {
  final String logoUrl;
  final String primaryColor;
  final String secondaryColor;
  final String appName;
  final String tagline;

  BrandConfig({
    required this.logoUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.appName,
    required this.tagline,
  });
}
