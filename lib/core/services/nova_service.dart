// Legacy adapter for NovaService
// Redirects to new NovaAIOrchestrator

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'nova_ai_orchestrator.dart';

/// Legacy NovaService - now uses NovaAIOrchestrator
class NovaService {
  final NovaAIOrchestrator orchestrator;
  
  NovaService({
    required String accessKeyId,
    required String secretAccessKey,
    required String region,
  }) : orchestrator = NovaAIOrchestrator(
          accessKeyId: accessKeyId,
          secretAccessKey: secretAccessKey,
          region: region,
        );

  // Legacy method - redirects to orchestrator
  Future<Map<String, dynamic>> sendMessage({
    required String prompt,
    Map<String, dynamic>? context,
    String? systemInstruction,
    bool? deepReasoning, // Ignored - for compatibility
    bool? thinkingLevel, // Ignored - for compatibility
  }) async {
    // Add system instruction to context if provided
    final fullContext = context ?? {};
    if (systemInstruction != null) {
      fullContext['systemInstruction'] = systemInstruction;
    }
    
    return await orchestrator.processFinancialMessage(
      message: prompt,
      context: fullContext,
    );
  }

  // Raw message method (no context processing)
  Future<Map<String, dynamic>> sendRawMessage({
    required String prompt,
    String? systemInstruction,
  }) async {
    return await sendMessage(
      prompt: prompt,
      systemInstruction: systemInstruction,
    );
  }

  // Receipt analysis method
  Future<Map<String, dynamic>> analyzeReceiptImage({
    required String base64Image,
    required String region,
    List<Map<String, dynamic>>? memoryContext,
  }) async {
    return await orchestrator.analyzeReceipt(
      base64Image: base64Image,
      region: region,
    );
  }
}

/// Provider for NovaService (legacy compatibility)
final novaServiceProvider = Provider<NovaService>((ref) {
  final accessKeyId = dotenv.env['AWS_ACCESS_KEY_ID'] ?? 'your_aws_access_key_id_here';
  final secretAccessKey = dotenv.env['AWS_SECRET_ACCESS_KEY'] ?? 'your_aws_secret_access_key_here';
  final region = dotenv.env['AWS_REGION'] ?? 'us-east-1';
  
  return NovaService(
    accessKeyId: accessKeyId,
    secretAccessKey: secretAccessKey,
    region: region,
  );
});
