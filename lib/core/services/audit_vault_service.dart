import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final auditVaultServiceProvider = Provider((ref) => AuditVaultService());

/// Audit Vault Service - Real AWS S3 Implementation
/// Stores immutable audit trails for compliance and financial records
class AuditVaultService {
  String? _userId;

  /// Initialize with user ID
  void initialize(String userId) {
    _userId = userId;
    safePrint('[Audit Vault] Initialized for user: $userId');
  }

  /// Save audit trail to S3
  Future<void> saveAuditTrail({
    required String receiptId,
    required Map<String, dynamic> auditData,
  }) async {
    if (_userId == null) {
      safePrint('[Audit Vault] ERROR: userId not initialized');
      return;
    }

    try {
      // Add metadata
      auditData['userId'] = _userId;
      auditData['savedAt'] = DateTime.now().toIso8601String();
      auditData['version'] = '1.0';

      // Convert to JSON
      final jsonData = jsonEncode(auditData);
      
      // S3 key: private/{userId}/receipts/{receiptId}/audit.json
      final key = 'receipts/$receiptId/audit.json';
      
      safePrint('[Audit Vault] Saving audit trail to S3: $key');
      
      // Upload to S3
      final result = await Amplify.Storage.uploadData(
        data: S3DataPayload.string(jsonData),
        path: StoragePath.fromString(key),
        options: const StorageUploadDataOptions(
          metadata: {
            'contentType': 'application/json',
            'receiptId': '',
          },
        ),
      ).result;
      
      safePrint('[Audit Vault] ✓ Audit trail saved: ${result.uploadedItem.path}');
    } catch (e) {
      safePrint('[Audit Vault] ❌ Error saving audit trail: $e');
      rethrow;
    }
  }

  /// Retrieve audit trail from S3
  Future<Map<String, dynamic>?> getAuditTrail(String receiptId) async {
    if (_userId == null) {
      safePrint('[Audit Vault] ERROR: userId not initialized');
      return null;
    }

    try {
      final key = 'receipts/$receiptId/audit.json';
      
      safePrint('[Audit Vault] Retrieving audit trail from S3: $key');
      
      // Download from S3
      final result = await Amplify.Storage.downloadData(
        path: StoragePath.fromString(key),
      ).result;
      
      // Parse JSON
      final jsonString = String.fromCharCodes(result.bytes);
      final auditData = jsonDecode(jsonString) as Map<String, dynamic>;
      
      safePrint('[Audit Vault] ✓ Audit trail retrieved');
      return auditData;
    } catch (e) {
      safePrint('[Audit Vault] ❌ Error retrieving audit trail: $e');
      return null;
    }
  }

  /// List all audit trails for user
  Future<List<String>> listAuditTrails() async {
    if (_userId == null) {
      safePrint('[Audit Vault] ERROR: userId not initialized');
      return [];
    }

    try {
      safePrint('[Audit Vault] Listing audit trails from S3');
      
      // List objects in S3
      final result = await Amplify.Storage.list(
        path: const StoragePath.fromString('receipts/'),
      ).result;
      
      final receiptIds = <String>[];
      for (final item in result.items) {
        // Extract receipt ID from path: receipts/{receiptId}/audit.json
        final pathParts = item.path.split('/');
        if (pathParts.length >= 2) {
          receiptIds.add(pathParts[1]);
        }
      }
      
      safePrint('[Audit Vault] ✓ Found ${receiptIds.length} audit trails');
      return receiptIds;
    } catch (e) {
      safePrint('[Audit Vault] ❌ Error listing audit trails: $e');
      return [];
    }
  }

  /// Save monthly audit summary
  Future<void> saveMonthlySummary({
    required int year,
    required int month,
    required Map<String, dynamic> summaryData,
  }) async {
    if (_userId == null) {
      safePrint('[Audit Vault] ERROR: userId not initialized');
      return;
    }

    try {
      // Add metadata
      summaryData['userId'] = _userId;
      summaryData['year'] = year;
      summaryData['month'] = month;
      summaryData['generatedAt'] = DateTime.now().toIso8601String();
      summaryData['version'] = '1.0';

      // Convert to JSON
      final jsonData = jsonEncode(summaryData);
      
      // S3 key: private/{userId}/summaries/{year}-{month}.json
      final key = 'summaries/$year-${month.toString().padLeft(2, '0')}.json';
      
      safePrint('[Audit Vault] Saving monthly summary to S3: $key');
      
      // Upload to S3
      final result = await Amplify.Storage.uploadData(
        data: S3DataPayload.string(jsonData),
        path: StoragePath.fromString(key),
        options: const StorageUploadDataOptions(
          metadata: {
            'contentType': 'application/json',
          },
        ),
      ).result;
      
      safePrint('[Audit Vault] ✓ Monthly summary saved: ${result.uploadedItem.path}');
    } catch (e) {
      safePrint('[Audit Vault] ❌ Error saving monthly summary: $e');
      rethrow;
    }
  }

  /// Get monthly audit summary
  Future<Map<String, dynamic>?> getMonthlySummary({
    required int year,
    required int month,
  }) async {
    if (_userId == null) {
      safePrint('[Audit Vault] ERROR: userId not initialized');
      return null;
    }

    try {
      final key = 'summaries/$year-${month.toString().padLeft(2, '0')}.json';
      
      safePrint('[Audit Vault] Retrieving monthly summary from S3: $key');
      
      // Download from S3
      final result = await Amplify.Storage.downloadData(
        path: StoragePath.fromString(key),
      ).result;
      
      // Parse JSON
      final jsonString = String.fromCharCodes(result.bytes);
      final summaryData = jsonDecode(jsonString) as Map<String, dynamic>;
      
      safePrint('[Audit Vault] ✓ Monthly summary retrieved');
      return summaryData;
    } catch (e) {
      safePrint('[Audit Vault] ❌ Error retrieving monthly summary: $e');
      return null;
    }
  }

  /// Upload receipt image to S3
  Future<String?> uploadReceiptImage({
    required String receiptId,
    required List<int> imageBytes,
    required String mimeType,
  }) async {
    if (_userId == null) {
      safePrint('[Audit Vault] ERROR: userId not initialized');
      return null;
    }

    try {
      // Determine file extension
      final extension = mimeType.contains('png') ? 'png' : 'jpg';
      
      // S3 key: private/{userId}/receipts/{receiptId}/image.{ext}
      final key = 'receipts/$receiptId/image.$extension';
      
      safePrint('[Audit Vault] Uploading receipt image to S3: $key');
      
      // Upload to S3
      final result = await Amplify.Storage.uploadData(
        data: S3DataPayload.bytes(imageBytes),
        path: StoragePath.fromString(key),
        options: StorageUploadDataOptions(
          metadata: {
            'contentType': mimeType,
            'receiptId': receiptId,
          },
        ),
      ).result;
      
      safePrint('[Audit Vault] ✓ Receipt image uploaded: ${result.uploadedItem.path}');
      return result.uploadedItem.path;
    } catch (e) {
      safePrint('[Audit Vault] ❌ Error uploading receipt image: $e');
      return null;
    }
  }

  /// Get receipt image URL from S3
  Future<String?> getReceiptImageUrl(String receiptId) async {
    if (_userId == null) {
      safePrint('[Audit Vault] ERROR: userId not initialized');
      return null;
    }

    try {
      // Try both jpg and png
      for (final ext in ['jpg', 'png']) {
        try {
          final key = 'receipts/$receiptId/image.$ext';
          
          // Get presigned URL
          final result = await Amplify.Storage.getUrl(
            path: StoragePath.fromString(key),
          ).result;
          
          safePrint('[Audit Vault] ✓ Receipt image URL generated');
          return result.url.toString();
        } catch (e) {
          // Try next extension
          continue;
        }
      }
      
      safePrint('[Audit Vault] ⚠️ Receipt image not found');
      return null;
    } catch (e) {
      safePrint('[Audit Vault] ❌ Error getting receipt image URL: $e');
      return null;
    }
  }
}
