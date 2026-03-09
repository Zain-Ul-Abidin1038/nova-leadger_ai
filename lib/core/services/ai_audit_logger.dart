import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

part 'ai_audit_logger.g.dart';

final aiAuditLoggerProvider = Provider((ref) => AIAuditLogger());

@HiveType(typeId: 5)
class AIAuditRecord {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final String action;

  @HiveField(2)
  final String model;

  @HiveField(3)
  final String inputSummary;

  @HiveField(4)
  final String outputSummary;

  @HiveField(5)
  final int tokenCount;

  @HiveField(6)
  final double cost;

  @HiveField(7)
  final String? thoughtSignature;

  @HiveField(8)
  final bool success;

  AIAuditRecord({
    required this.timestamp,
    required this.action,
    required this.model,
    required this.inputSummary,
    required this.outputSummary,
    required this.tokenCount,
    required this.cost,
    this.thoughtSignature,
    required this.success,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'action': action,
      'model': model,
      'inputSummary': inputSummary,
      'outputSummary': outputSummary,
      'tokenCount': tokenCount,
      'cost': cost,
      'thoughtSignature': thoughtSignature,
      'success': success,
    };
  }

  factory AIAuditRecord.fromJson(Map<String, dynamic> json) {
    return AIAuditRecord(
      timestamp: DateTime.parse(json['timestamp'] as String),
      action: json['action'] as String,
      model: json['model'] as String,
      inputSummary: json['inputSummary'] as String,
      outputSummary: json['outputSummary'] as String,
      tokenCount: json['tokenCount'] as int,
      cost: (json['cost'] as num).toDouble(),
      thoughtSignature: json['thoughtSignature'] as String?,
      success: json['success'] as bool,
    );
  }
}

/// AI Audit Trail (Compliance Layer)
/// 
/// Tracks how AI decisions were made for:
/// - Compliance and audit requirements
/// - Debugging AI behavior
/// - Cost analysis
/// - Performance monitoring
class AIAuditLogger {
  static const String _boxName = 'ai_audit_log';
  Box<AIAuditRecord>? _box;

  final List<AIAuditRecord> _memoryCache = [];
  static const int _maxCacheSize = 100;

  Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(AIAuditRecordAdapter());
    }
    _box = await Hive.openBox<AIAuditRecord>(_boxName);
    safePrint('[AIAuditLogger] Initialized with ${_box?.length ?? 0} records');
  }

  /// Record an AI action
  Future<void> record({
    required String action,
    required String model,
    required Map<String, dynamic> input,
    required Map<String, dynamic> output,
    int tokenCount = 0,
    double cost = 0.0,
    String? thoughtSignature,
    bool success = true,
  }) async {
    final record = AIAuditRecord(
      timestamp: DateTime.now(),
      action: action,
      model: model,
      inputSummary: _summarizeData(input),
      outputSummary: _summarizeData(output),
      tokenCount: tokenCount,
      cost: cost,
      thoughtSignature: thoughtSignature,
      success: success,
    );

    // Add to memory cache
    _memoryCache.add(record);
    if (_memoryCache.length > _maxCacheSize) {
      _memoryCache.removeAt(0);
    }

    // Persist to Hive
    await _box?.add(record);

    safePrint('[AIAuditLogger] Recorded: $action ($model) - ${success ? "✓" : "✗"}');
  }

  /// Get all audit records
  List<AIAuditRecord> getAllRecords() {
    return _box?.values.toList() ?? [];
  }

  /// Get records by action type
  List<AIAuditRecord> getRecordsByAction(String action) {
    return _box?.values
        .where((r) => r.action == action)
        .toList() ?? [];
  }

  /// Get records by date range
  List<AIAuditRecord> getRecordsByDateRange(DateTime start, DateTime end) {
    return _box?.values
        .where((r) => r.timestamp.isAfter(start) && r.timestamp.isBefore(end))
        .toList() ?? [];
  }

  /// Get recent records from memory cache
  List<AIAuditRecord> getRecentRecords({int limit = 20}) {
    return _memoryCache.reversed.take(limit).toList();
  }

  /// Get audit statistics
  Map<String, dynamic> getStatistics() {
    final records = _box?.values.toList() ?? [];

    if (records.isEmpty) {
      return {
        'totalRecords': 0,
        'successRate': 0.0,
        'totalCost': 0.0,
        'totalTokens': 0,
        'actionBreakdown': {},
        'modelBreakdown': {},
      };
    }

    final successCount = records.where((r) => r.success).length;
    final totalCost = records.fold(0.0, (sum, r) => sum + r.cost);
    final totalTokens = records.fold(0, (sum, r) => sum + r.tokenCount);

    final actionBreakdown = <String, int>{};
    final modelBreakdown = <String, int>{};

    for (final record in records) {
      actionBreakdown[record.action] = (actionBreakdown[record.action] ?? 0) + 1;
      modelBreakdown[record.model] = (modelBreakdown[record.model] ?? 0) + 1;
    }

    return {
      'totalRecords': records.length,
      'successRate': (successCount / records.length) * 100,
      'totalCost': totalCost,
      'totalTokens': totalTokens,
      'actionBreakdown': actionBreakdown,
      'modelBreakdown': modelBreakdown,
      'averageCost': totalCost / records.length,
      'averageTokens': totalTokens / records.length,
    };
  }

  /// Export audit log for compliance
  Future<List<Map<String, dynamic>>> exportForCompliance({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var records = _box?.values.toList() ?? [];

    if (startDate != null) {
      records = records.where((r) => r.timestamp.isAfter(startDate)).toList();
    }

    if (endDate != null) {
      records = records.where((r) => r.timestamp.isBefore(endDate)).toList();
    }

    return records.map((r) => r.toJson()).toList();
  }

  /// Clear old records (retention policy)
  Future<void> clearOldRecords({int daysToKeep = 90}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    final keysToDelete = <dynamic>[];

    for (final key in _box?.keys ?? []) {
      final record = _box?.get(key);
      if (record != null && record.timestamp.isBefore(cutoffDate)) {
        keysToDelete.add(key);
      }
    }

    for (final key in keysToDelete) {
      await _box?.delete(key);
    }

    safePrint('[AIAuditLogger] Cleared ${keysToDelete.length} old records');
  }

  /// Clear all records
  Future<void> clearAll() async {
    await _box?.clear();
    _memoryCache.clear();
    safePrint('[AIAuditLogger] Cleared all audit records');
  }

  String _summarizeData(Map<String, dynamic> data) {
    // Create concise summary of data (max 200 chars)
    final summary = data.entries
        .take(3)
        .map((e) => '${e.key}:${_truncate(e.value.toString(), 30)}')
        .join(', ');

    return _truncate(summary, 200);
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
}
