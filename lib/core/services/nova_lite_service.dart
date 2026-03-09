import 'dart:convert';
import 'package:http/http.dart' as http;

/// Nova 2 Lite Reasoning Engine
/// Handles financial insights, decision synthesis, budget analysis,
/// cashflow forecasting, and chat assistance using Amazon Nova 2 Lite
class NovaLiteService {
  final String apiKey;
  final String region;
  static const String _baseUrl = 'https://bedrock-runtime';
  
  NovaLiteService({
    required this.apiKey,
    required this.region,
  });

  /// Send a message to Nova Lite for financial reasoning
  Future<Map<String, dynamic>> sendMessage({
    required String prompt,
    Map<String, dynamic>? context,
    bool deepReasoning = false,
  }) async {
    try {
      final endpoint = '$_baseUrl.$region.amazonaws.com/model/amazon.nova-lite-v1:0/invoke';
      
      final requestBody = {
        'messages': [
          {
            'role': 'user',
            'content': [
              {'text': prompt}
            ]
          }
        ],
        'inferenceConfig': {
          'temperature': deepReasoning ? 0.3 : 0.7,
          'maxTokens': 2048,
        },
        if (context != null) 'system': [
          {
            'text': 'Financial context: ${jsonEncode(context)}'
          }
        ],
      };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['output']['message']['content'][0]['text'],
          'usage': data['usage'],
        };
      } else {
        return {
          'success': false,
          'error': 'Nova Lite API error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Nova Lite service error: $e',
      };
    }
  }

  /// Generate financial insights using Nova Lite
  Future<Map<String, dynamic>> generateFinancialInsight({
    required Map<String, dynamic> financialData,
    required String insightType,
  }) async {
    final prompt = '''
Analyze the following financial data and provide ${insightType} insights:

${jsonEncode(financialData)}

Provide actionable recommendations and predictions.
''';

    return await sendMessage(
      prompt: prompt,
      context: financialData,
      deepReasoning: true,
    );
  }

  /// Forecast cashflow using Nova Lite reasoning
  Future<Map<String, dynamic>> forecastCashflow({
    required List<Map<String, dynamic>> transactions,
    required int daysAhead,
  }) async {
    final prompt = '''
Based on these transactions, forecast cashflow for the next $daysAhead days:

${jsonEncode(transactions)}

Provide daily balance predictions and identify potential shortfalls.
''';

    return await sendMessage(
      prompt: prompt,
      deepReasoning: true,
    );
  }

  /// Analyze budget performance
  Future<Map<String, dynamic>> analyzeBudget({
    required Map<String, dynamic> budgetData,
    required Map<String, dynamic> spendingData,
  }) async {
    final prompt = '''
Compare budget vs actual spending:

Budget: ${jsonEncode(budgetData)}
Spending: ${jsonEncode(spendingData)}

Identify overspending categories and suggest optimizations.
''';

    return await sendMessage(
      prompt: prompt,
      deepReasoning: true,
    );
  }

  /// Process chat message with financial context
  Future<Map<String, dynamic>> processChat({
    required String message,
    required Map<String, dynamic> financialContext,
    List<Map<String, String>>? conversationHistory,
  }) async {
    return await sendMessage(
      prompt: message,
      context: financialContext,
      deepReasoning: false,
    );
  }
}
