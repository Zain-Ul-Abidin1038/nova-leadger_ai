import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

final financialLearningMemoryProvider = Provider((ref) => FinancialLearningMemory());

/// Financial Learning Memory
/// Self-learning system that improves over time based on user actions
/// 
/// Learns:
/// - Category corrections
/// - Vendor patterns
/// - User risk tolerance
/// - Spending habits
/// - Advice effectiveness
class FinancialLearningMemory {
  static const String _boxName = 'learning_memory';
  Box<dynamic>? _box;

  Future<void> initialize() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Learn from user action
  void learn(String key, dynamic value) {
    _box?.put(key, value);
    safePrint('[LearningMemory] Learned: $key = $value');
  }

  /// Recall learned value
  dynamic recall(String key) {
    return _box?.get(key);
  }

  /// Update from user action (reinforcement learning)
  void updateFromUserAction(String advice, bool accepted) {
    final currentScore = recall(advice) ?? 0;
    final newScore = accepted ? currentScore + 1 : currentScore - 1;
    learn(advice, newScore);
    
    safePrint('[LearningMemory] Updated advice score: $advice = $newScore');
  }

  /// Learn category preference
  void learnCategoryPreference(String vendor, String category) {
    final key = 'category_$vendor';
    final currentCount = recall(key) ?? 0;
    learn(key, currentCount + 1);
    learn('${key}_preferred', category);
  }

  /// Get preferred category for vendor
  String? getPreferredCategory(String vendor) {
    return recall('category_${vendor}_preferred');
  }

  /// Learn spending pattern
  void learnSpendingPattern(String category, double amount, String timeOfDay) {
    final key = 'pattern_${category}_${timeOfDay}';
    final amounts = (recall(key) as List<double>?) ?? [];
    amounts.add(amount);
    if (amounts.length > 100) amounts.removeAt(0); // Keep last 100
    learn(key, amounts);
  }

  /// Get average spending for pattern
  double? getAverageSpending(String category, String timeOfDay) {
    final key = 'pattern_${category}_${timeOfDay}';
    final amounts = (recall(key) as List<double>?) ?? [];
    if (amounts.isEmpty) return null;
    return amounts.reduce((a, b) => a + b) / amounts.length;
  }

  /// Learn risk tolerance
  void learnRiskTolerance(String action, bool accepted) {
    final key = 'risk_tolerance_$action';
    updateFromUserAction(key, accepted);
  }

  /// Get risk tolerance score
  int getRiskToleranceScore(String action) {
    return recall('risk_tolerance_$action') ?? 0;
  }

  /// Learn advice effectiveness
  void learnAdviceEffectiveness(String adviceType, bool followed) {
    final key = 'advice_effectiveness_$adviceType';
    final stats = recall(key) ?? {'shown': 0, 'followed': 0};
    stats['shown'] = (stats['shown'] ?? 0) + 1;
    if (followed) stats['followed'] = (stats['followed'] ?? 0) + 1;
    learn(key, stats);
  }

  /// Get advice effectiveness rate
  double getAdviceEffectivenessRate(String adviceType) {
    final stats = recall('advice_effectiveness_$adviceType');
    if (stats == null) return 0.0;
    final shown = stats['shown'] ?? 0;
    final followed = stats['followed'] ?? 0;
    if (shown == 0) return 0.0;
    return followed / shown;
  }

  /// Learn user preference
  void learnPreference(String preferenceKey, dynamic value) {
    learn('pref_$preferenceKey', value);
  }

  /// Get user preference
  dynamic getPreference(String preferenceKey) {
    return recall('pref_$preferenceKey');
  }

  /// Get all learned patterns
  Map<String, dynamic> getAllPatterns() {
    final patterns = <String, dynamic>{};
    for (final key in _box?.keys ?? []) {
      patterns[key.toString()] = _box?.get(key);
    }
    return patterns;
  }

  /// Export learning data
  Map<String, dynamic> exportLearningData() {
    return getAllPatterns();
  }

  /// Import learning data
  Future<void> importLearningData(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      await _box?.put(entry.key, entry.value);
    }
    safePrint('[LearningMemory] Imported ${data.length} patterns');
  }

  /// Clear all learning data
  Future<void> clearAll() async {
    await _box?.clear();
    safePrint('[LearningMemory] Cleared all learning data');
  }

  /// Get learning statistics
  Map<String, dynamic> getStatistics() {
    final patterns = getAllPatterns();
    
    final categoryLearnings = patterns.keys
        .where((k) => k.startsWith('category_'))
        .length;
    
    final adviceScores = patterns.keys
        .where((k) => k.startsWith('advice_effectiveness_'))
        .length;
    
    final riskScores = patterns.keys
        .where((k) => k.startsWith('risk_tolerance_'))
        .length;

    return {
      'totalPatterns': patterns.length,
      'categoryLearnings': categoryLearnings,
      'adviceScores': adviceScores,
      'riskScores': riskScores,
    };
  }
}
