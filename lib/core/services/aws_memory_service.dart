import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final awsMemoryServiceProvider = Provider((ref) => AWSMemoryService());

/// AWS Memory Service - S3-based Implementation
/// Stores financial memories, thought signatures, and user patterns in S3
class AWSMemoryService {
  String? _userId;
  final List<Map<String, dynamic>> _memoryCache = [];

  /// Initialize memory with user ID
  void initialize(String userId) {
    _userId = userId;
    safePrint('[AWS Memory] Initialized with userId: $userId');
    _loadMemoryIndex();
  }

  /// Store a financial memory event in S3
  Future<void> putMemoryEvent({
    required String thoughtSignature,
    required String category,
    required Map<String, dynamic> metadata,
  }) async {
    if (_userId == null) {
      safePrint('[AWS Memory] ERROR: userId not initialized');
      return;
    }

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final memoryId = 'memory_$timestamp';
      
      // Prepare memory object
      final memoryData = {
        'id': memoryId,
        'userId': _userId,
        'timestamp': timestamp,
        'thoughtSignature': thoughtSignature,
        'category': category,
        'metadata': metadata,
        'createdAt': DateTime.now().toIso8601String(),
      };

      safePrint('[AWS Memory] Storing memory event: $category');
      
      // Save to S3: memories/{memoryId}.json
      final key = 'memories/$memoryId.json';
      final jsonData = jsonEncode(memoryData);
      
      await Amplify.Storage.uploadData(
        data: S3DataPayload.string(jsonData),
        path: StoragePath.fromString(key),
        options: const StorageUploadDataOptions(
          metadata: {
            'contentType': 'application/json',
          },
        ),
      ).result;
      
      // Add to cache
      _memoryCache.add(memoryData);
      
      // Update memory index
      await _updateMemoryIndex();
      
      safePrint('[AWS Memory] ✓ Memory event stored');
    } catch (e) {
      safePrint('[AWS Memory] ❌ Error storing memory: $e');
      // Don't rethrow - memory storage is non-critical
    }
  }

  /// Retrieve financial stories from memory
  Future<List<String>> getMemoryStories({
    int limit = 5,
    List<String>? filterTags,
  }) async {
    if (_userId == null) {
      safePrint('[AWS Memory] ERROR: userId not initialized');
      return [];
    }

    try {
      safePrint('[AWS Memory] Retrieving top $limit stories');
      
      // Load memory index if cache is empty
      if (_memoryCache.isEmpty) {
        await _loadMemoryIndex();
      }
      
      // Sort by timestamp (newest first)
      _memoryCache.sort((a, b) => 
        (b['timestamp'] as int).compareTo(a['timestamp'] as int)
      );
      
      // Filter and extract thought signatures
      final stories = <String>[];
      
      for (final memory in _memoryCache) {
        if (stories.length >= limit) break;
        
        final thoughtSignature = memory['thoughtSignature'] as String?;
        final category = memory['category'] as String?;
        
        if (thoughtSignature != null) {
          // Filter by tags if provided
          if (filterTags == null || 
              filterTags.any((tag) => 
                thoughtSignature.toLowerCase().contains(tag.toLowerCase()) ||
                (category?.toLowerCase().contains(tag.toLowerCase()) ?? false)
              )) {
            stories.add(thoughtSignature);
          }
        }
      }
      
      safePrint('[AWS Memory] ✓ Retrieved ${stories.length} stories');
      return stories;
    } catch (e) {
      safePrint('[AWS Memory] ❌ Error retrieving memories: $e');
      return [];
    }
  }

  /// Get recent memories (alias for getMemoryStories)
  Future<List<String>> getRecentMemories({int limit = 5}) async {
    return getMemoryStories(limit: limit);
  }

  /// Store social ledger entry (IOU tracking)
  Future<void> storeSocialLedgerEntry({
    required String personName,
    required double amount,
    required String type, // 'lent' or 'borrowed'
    required DateTime date,
  }) async {
    final thoughtSignature = 'User $type \$${amount.toStringAsFixed(2)} ${type == 'lent' ? 'to' : 'from'} $personName on ${date.toLocal().toString().split(' ')[0]}';
    
    await putMemoryEvent(
      thoughtSignature: thoughtSignature,
      category: 'Social Ledger',
      metadata: {
        'personName': personName,
        'amount': amount,
        'type': type,
        'date': date.toIso8601String(),
        'status': 'unpaid',
        'tags': ['loan', 'owed', 'social'],
      },
    );
  }

  /// Store financial guardrail warning
  Future<void> storeFinancialWarning({
    required String warningType,
    required String message,
    required Map<String, dynamic> context,
  }) async {
    await putMemoryEvent(
      thoughtSignature: 'Financial Warning: $message',
      category: 'Financial Guardrail',
      metadata: {
        'warningType': warningType,
        'message': message,
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
        'tags': ['warning', 'guardrail'],
      },
    );
  }

  /// Get unpaid IOUs
  Future<List<Map<String, dynamic>>> getUnpaidIOUs() async {
    final stories = await getMemoryStories(
      limit: 50,
      filterTags: ['loan', 'owed'],
    );

    // Parse stories to extract IOU information
    final ious = <Map<String, dynamic>>[];
    
    for (final story in stories) {
      if (story.contains('lent') || story.contains('borrowed')) {
        ious.add({
          'description': story,
          'status': 'unpaid',
        });
      }
    }
    
    return ious;
  }

  /// Check for cash crunch patterns
  Future<bool> detectCashCrunch() async {
    final stories = await getMemoryStories(
      limit: 20,
      filterTags: ['warning', 'guardrail'],
    );

    // Simple heuristic: if there are recent warnings, flag cash crunch
    return stories.any((story) => 
      story.toLowerCase().contains('warning') || 
      story.toLowerCase().contains('crunch') ||
      story.toLowerCase().contains('low balance')
    );
  }

  /// Get spending patterns by category
  Future<Map<String, double>> getSpendingByCategory({
    int days = 30,
  }) async {
    if (_userId == null) {
      safePrint('[AWS Memory] ERROR: userId not initialized');
      return {};
    }

    try {
      // Load memory index if cache is empty
      if (_memoryCache.isEmpty) {
        await _loadMemoryIndex();
      }
      
      final cutoffTimestamp = DateTime.now()
          .subtract(Duration(days: days))
          .millisecondsSinceEpoch;
      
      // Aggregate by category
      final spending = <String, double>{};
      
      for (final memory in _memoryCache) {
        final timestamp = memory['timestamp'] as int?;
        if (timestamp == null || timestamp < cutoffTimestamp) continue;
        
        final category = memory['category'] as String?;
        final metadata = memory['metadata'] as Map<String, dynamic>?;
        
        if (category != null && metadata != null) {
          final amount = (metadata['total'] ?? metadata['amount'] ?? 0.0) as num;
          spending[category] = (spending[category] ?? 0.0) + amount.toDouble();
        }
      }
      
      return spending;
    } catch (e) {
      safePrint('[AWS Memory] ❌ Error getting spending patterns: $e');
      return {};
    }
  }

  /// Load memory index from S3
  Future<void> _loadMemoryIndex() async {
    if (_userId == null) return;

    try {
      safePrint('[AWS Memory] Loading memory index from S3...');
      
      // Try to load index file
      final indexKey = 'memories/index.json';
      
      try {
        final result = await Amplify.Storage.downloadData(
          path: StoragePath.fromString(indexKey),
        ).result;
        
        final jsonString = String.fromCharCodes(result.bytes);
        final indexData = jsonDecode(jsonString) as Map<String, dynamic>;
        final memories = indexData['memories'] as List? ?? [];
        
        _memoryCache.clear();
        _memoryCache.addAll(memories.cast<Map<String, dynamic>>());
        
        safePrint('[AWS Memory] ✓ Loaded ${_memoryCache.length} memories from index');
      } catch (e) {
        // Index doesn't exist yet - that's okay
        safePrint('[AWS Memory] No existing memory index found (this is normal for new users)');
      }
    } catch (e) {
      safePrint('[AWS Memory] ❌ Error loading memory index: $e');
    }
  }

  /// Update memory index in S3
  Future<void> _updateMemoryIndex() async {
    if (_userId == null) return;

    try {
      // Keep only last 100 memories in index
      if (_memoryCache.length > 100) {
        _memoryCache.sort((a, b) => 
          (b['timestamp'] as int).compareTo(a['timestamp'] as int)
        );
        _memoryCache.removeRange(100, _memoryCache.length);
      }
      
      final indexData = {
        'userId': _userId,
        'lastUpdated': DateTime.now().toIso8601String(),
        'count': _memoryCache.length,
        'memories': _memoryCache,
      };
      
      final indexKey = 'memories/index.json';
      final jsonData = jsonEncode(indexData);
      
      await Amplify.Storage.uploadData(
        data: S3DataPayload.string(jsonData),
        path: StoragePath.fromString(indexKey),
        options: const StorageUploadDataOptions(
          metadata: {
            'contentType': 'application/json',
          },
        ),
      ).result;
      
      safePrint('[AWS Memory] ✓ Memory index updated');
    } catch (e) {
      safePrint('[AWS Memory] ❌ Error updating memory index: $e');
    }
  }
}
