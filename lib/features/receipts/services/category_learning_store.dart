import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

final categoryLearningStoreProvider = Provider((ref) => CategoryLearningStore());

/// Smart Receipt Categorization Learning
/// 
/// System improves categorization over time by learning from user corrections
/// - Stores vendor → category mappings
/// - Predicts categories for known vendors
/// - Improves accuracy with each correction
class CategoryLearningStore {
  static const String _boxName = 'category_learning';
  Box<String>? _box;

  final Map<String, String> _vendorCategoryMap = {};
  final Map<String, int> _categoryConfidence = {};

  Future<void> initialize() async {
    _box = await Hive.openBox<String>(_boxName);
    _loadMappings();
    safePrint('[CategoryLearning] Initialized with ${_vendorCategoryMap.length} mappings');
  }

  /// Learn from user correction
  Future<void> learn(String vendor, String category) async {
    final key = _normalizeVendor(vendor);
    
    _vendorCategoryMap[key] = category;
    _categoryConfidence[key] = (_categoryConfidence[key] ?? 0) + 1;

    await _box?.put(key, category);
    
    safePrint('[CategoryLearning] Learned: $vendor → $category (confidence: ${_categoryConfidence[key]})');
  }

  /// Predict category for vendor
  String? predict(String vendor) {
    final key = _normalizeVendor(vendor);
    final prediction = _vendorCategoryMap[key];
    
    if (prediction != null) {
      safePrint('[CategoryLearning] Predicted: $vendor → $prediction');
    }
    
    return prediction;
  }

  /// Get confidence score for prediction (0-100)
  int getConfidence(String vendor) {
    final key = _normalizeVendor(vendor);
    final count = _categoryConfidence[key] ?? 0;
    
    // Confidence increases with repeated corrections
    // Max out at 95% after 10+ corrections
    return (count * 10).clamp(0, 95);
  }

  /// Get all learned mappings
  Map<String, String> getAllMappings() {
    return Map.from(_vendorCategoryMap);
  }

  /// Get learning statistics
  Map<String, dynamic> getStatistics() {
    final totalMappings = _vendorCategoryMap.length;
    final highConfidence = _categoryConfidence.values
        .where((count) => count >= 5)
        .length;

    final categoryDistribution = <String, int>{};
    for (final category in _vendorCategoryMap.values) {
      categoryDistribution[category] = (categoryDistribution[category] ?? 0) + 1;
    }

    return {
      'totalMappings': totalMappings,
      'highConfidenceMappings': highConfidence,
      'categoryDistribution': categoryDistribution,
      'averageConfidence': _calculateAverageConfidence(),
    };
  }

  /// Clear all learned mappings
  Future<void> clear() async {
    _vendorCategoryMap.clear();
    _categoryConfidence.clear();
    await _box?.clear();
    safePrint('[CategoryLearning] Cleared all mappings');
  }

  /// Export mappings for backup
  Map<String, dynamic> export() {
    return {
      'mappings': _vendorCategoryMap,
      'confidence': _categoryConfidence,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  /// Import mappings from backup
  Future<void> import(Map<String, dynamic> data) async {
    final mappings = data['mappings'] as Map<String, dynamic>?;
    final confidence = data['confidence'] as Map<String, dynamic>?;

    if (mappings != null) {
      for (final entry in mappings.entries) {
        _vendorCategoryMap[entry.key] = entry.value as String;
        await _box?.put(entry.key, entry.value as String);
      }
    }

    if (confidence != null) {
      for (final entry in confidence.entries) {
        _categoryConfidence[entry.key] = entry.value as int;
      }
    }

    safePrint('[CategoryLearning] Imported ${_vendorCategoryMap.length} mappings');
  }

  void _loadMappings() {
    if (_box == null) return;

    for (final key in _box!.keys) {
      final category = _box!.get(key);
      if (category != null) {
        _vendorCategoryMap[key as String] = category;
        _categoryConfidence[key] = 1; // Default confidence
      }
    }
  }

  String _normalizeVendor(String vendor) {
    // Normalize vendor name for consistent matching
    return vendor
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  double _calculateAverageConfidence() {
    if (_categoryConfidence.isEmpty) return 0;

    final total = _categoryConfidence.values.fold(0, (sum, count) => sum + count);
    return total / _categoryConfidence.length;
  }

  /// Suggest category based on partial vendor name
  List<String> suggestCategories(String partialVendor) {
    final normalized = _normalizeVendor(partialVendor);
    final suggestions = <String>[];

    for (final entry in _vendorCategoryMap.entries) {
      if (entry.key.contains(normalized)) {
        if (!suggestions.contains(entry.value)) {
          suggestions.add(entry.value);
        }
      }
    }

    return suggestions;
  }
}
