/// Coach Action Model
/// Represents a financial coaching recommendation
class CoachAction {
  final String type;
  final String message;
  final int priority; // 1-10, higher = more urgent
  final DateTime timestamp;
  final String? actionUrl; // Deep link to relevant screen

  CoachAction({
    required this.type,
    required this.message,
    required this.priority,
    DateTime? timestamp,
    this.actionUrl,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isUrgent => priority >= 8;
  bool get isHighPriority => priority >= 6;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'priority': priority,
      'timestamp': timestamp.toIso8601String(),
      'actionUrl': actionUrl,
    };
  }

  factory CoachAction.fromJson(Map<String, dynamic> json) {
    return CoachAction(
      type: json['type'] as String,
      message: json['message'] as String,
      priority: json['priority'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      actionUrl: json['actionUrl'] as String?,
    );
  }
}
