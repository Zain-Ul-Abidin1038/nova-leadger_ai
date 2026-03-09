import 'nova_lite_service.dart';
import 'nova_embedding_service.dart';
import 'nova_agent_executor.dart';
import 'nova_receipt_analyzer.dart';

/// Nova AI Orchestrator
/// Master orchestrator for all Amazon Nova AI services
/// Replaces NovaServiceV3 with Nova-based architecture
class NovaAIOrchestrator {
  final NovaLiteService liteService;
  final NovaEmbeddingService embeddingService;
  final NovaAgentExecutor agentExecutor;
  final NovaReceiptAnalyzer receiptAnalyzer;
  
  NovaAIOrchestrator({
    required String apiKey,
    required String region,
  })  : liteService = NovaLiteService(apiKey: apiKey, region: region),
        embeddingService = NovaEmbeddingService(apiKey: apiKey, region: region),
        agentExecutor = NovaAgentExecutor(apiKey: apiKey, region: region),
        receiptAnalyzer = NovaReceiptAnalyzer(apiKey: apiKey, region: region);

  /// Process financial message with context
  Future<Map<String, dynamic>> processFinancialMessage({
    required String message,
    required Map<String, dynamic> context,
  }) async {
    return await liteService.sendMessage(
      prompt: message,
      context: context,
    );
  }

  /// Analyze receipt with full pipeline
  Future<Map<String, dynamic>> analyzeReceipt({
    required String base64Image,
    required String region,
  }) async {
    return await receiptAnalyzer.analyzeReceipt(
      base64Image: base64Image,
      region: region,
    );
  }

  /// Search knowledge base
  Future<List<Map<String, dynamic>>> searchKnowledge({
    required String query,
    required List<Map<String, dynamic>> knowledgeBase,
  }) async {
    return await embeddingService.searchFinancialKnowledge(
      query: query,
      knowledgeBase: knowledgeBase,
    );
  }

  /// Execute autonomous task
  Future<Map<String, dynamic>> executeAutonomousTask({
    required String taskDescription,
    required String taskType,
    Map<String, dynamic>? parameters,
  }) async {
    return await agentExecutor.executeTask(
      taskDescription: taskDescription,
      taskType: taskType,
      parameters: parameters,
    );
  }

  /// Generate financial insights
  Future<Map<String, dynamic>> generateInsights({
    required Map<String, dynamic> financialData,
    required String insightType,
  }) async {
    return await liteService.generateFinancialInsight(
      financialData: financialData,
      insightType: insightType,
    );
  }

  /// Forecast cashflow
  Future<Map<String, dynamic>> forecastCashflow({
    required List<Map<String, dynamic>> transactions,
    required int daysAhead,
  }) async {
    return await liteService.forecastCashflow(
      transactions: transactions,
      daysAhead: daysAhead,
    );
  }
}
