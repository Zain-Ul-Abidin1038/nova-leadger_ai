/// Agent Result
/// Output from a specialized financial agent
class AgentResult {
  final String agentName;
  final String agentType;
  final double confidence;
  final Map<String, dynamic> insights;
  final List<String> recommendations;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  AgentResult({
    required this.agentName,
    required this.agentType,
    required this.confidence,
    required this.insights,
    required this.recommendations,
    this.metadata = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// High confidence result
  bool get isHighConfidence => confidence >= 0.8;

  /// Has actionable recommendations
  bool get hasRecommendations => recommendations.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'agentName': agentName,
        'agentType': agentType,
        'confidence': confidence,
        'insights': insights,
        'recommendations': recommendations,
        'metadata': metadata,
        'timestamp': timestamp.toIso8601String(),
      };
}
