// API Key domain model

class ApiKey {
  final String id;
  final String name;
  final String key;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final List<String> permissions;
  final int requestCount;
  final DateTime? lastUsed;

  ApiKey({
    required this.id,
    required this.name,
    required this.key,
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
    this.permissions = const [],
    this.requestCount = 0,
    this.lastUsed,
  });
}
