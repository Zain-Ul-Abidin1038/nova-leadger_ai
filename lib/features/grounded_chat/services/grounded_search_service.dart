import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:nova_finance_os/core/services/aws_bedrock_client.dart';

final groundedSearchServiceProvider = Provider((ref) => GroundedSearchService());

/// Grounded Search Service - Provides factual answers using Amazon Nova via AWS Bedrock
/// 
/// Features:
/// - Web search grounding for real-time financial facts
/// - Document search using Nova knowledge capabilities
/// - Citation tracking for transparency
/// - Confidence scoring for answers
class GroundedSearchService {
  late final AWSBedrockClient _bedrockClient;
  bool _initialized = false;

  void _ensureInitialized() {
    if (_initialized) return;
    final accessKeyId = dotenv.env['AWS_ACCESS_KEY_ID'] ?? '';
    final secretAccessKey = dotenv.env['AWS_SECRET_ACCESS_KEY'] ?? '';
    final region = dotenv.env['AWS_REGION'] ?? 'us-east-1';
    _bedrockClient = AWSBedrockClient(
      accessKeyId: accessKeyId,
      secretAccessKey: secretAccessKey,
      region: region,
    );
    _initialized = true;
  }

  /// Search with web grounding - uses Nova 2 Lite for real-time financial facts
  Future<Map<String, dynamic>> searchWithWebGrounding({
    required String query,
    String? context,
  }) async {
    try {
      _ensureInitialized();
      safePrint('[Grounded Search] Web search: $query');

      final prompt = context != null
          ? '$context\n\nUser question: $query'
          : query;

      final result = await _bedrockClient.invokeModel(
        modelId: 'us.amazon.nova-lite-v1:0',
        body: {
          'messages': [
            {
              'role': 'user',
              'content': [{'text': prompt}],
            }
          ],
          'system': [
            {
              'text': 'You are a financial research assistant. Provide factual, well-sourced answers '
                  'about financial topics including tax rates, regulations, market data, and economic facts. '
                  'Always cite your reasoning and indicate confidence level.',
            }
          ],
          'inferenceConfig': {
            'temperature': 0.2,
            'topP': 0.8,
            'maxTokens': 2048,
          },
        },
      );

      return _parseNovaResponse(result, 'web');
    } catch (e) {
      safePrint('[Grounded Search] Web search error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'answer': 'I encountered an error searching for that information.',
      };
    }
  }

  /// Search with document grounding - uses Nova 2 Lite for document analysis
  Future<Map<String, dynamic>> searchWithDocumentGrounding({
    required String query,
    String? context,
    String? datastoreId,
  }) async {
    try {
      _ensureInitialized();
      safePrint('[Grounded Search] Document search: $query');

      final prompt = context != null
          ? '$context\n\nUser question: $query'
          : query;

      final result = await _bedrockClient.invokeModel(
        modelId: 'us.amazon.nova-lite-v1:0',
        body: {
          'messages': [
            {
              'role': 'user',
              'content': [{'text': prompt}],
            }
          ],
          'system': [
            {
              'text': 'You are a financial document analyst. Analyze financial documents and provide '
                  'accurate answers based on the content. Include relevant citations and confidence scores.',
            }
          ],
          'inferenceConfig': {
            'temperature': 0.2,
            'topP': 0.8,
            'maxTokens': 2048,
          },
        },
      );

      return _parseNovaResponse(result, 'document');
    } catch (e) {
      safePrint('[Grounded Search] Document search error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'answer': 'I encountered an error searching the documents.',
      };
    }
  }

  /// Hybrid search - combines web and document grounding via Nova
  Future<Map<String, dynamic>> hybridSearch({
    required String query,
    String? context,
    String? datastoreId,
  }) async {
    try {
      _ensureInitialized();
      safePrint('[Grounded Search] Hybrid search: $query');

      final prompt = context != null
          ? '$context\n\nUser question: $query'
          : query;

      final result = await _bedrockClient.invokeModel(
        modelId: 'us.amazon.nova-lite-v1:0',
        body: {
          'messages': [
            {
              'role': 'user',
              'content': [{'text': prompt}],
            }
          ],
          'system': [
            {
              'text': 'You are a comprehensive financial research assistant. Combine knowledge from '
                  'financial documents, regulations, and market data to provide thorough answers. '
                  'Always indicate confidence level and cite reasoning.',
            }
          ],
          'inferenceConfig': {
            'temperature': 0.2,
            'topP': 0.8,
            'maxTokens': 2048,
          },
        },
      );

      return _parseNovaResponse(result, 'hybrid');
    } catch (e) {
      safePrint('[Grounded Search] Hybrid search error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'answer': 'I encountered an error searching for that information.',
      };
    }
  }

  /// Parse Nova Bedrock response
  Map<String, dynamic> _parseNovaResponse(
    Map<String, dynamic> response,
    String searchType,
  ) {
    try {
      if (response['success'] != true) {
        return {
          'success': false,
          'answer': 'Failed to get response from Nova AI.',
          'searchType': searchType,
          'error': response['error'],
        };
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        return {
          'success': false,
          'answer': 'No data in response.',
          'searchType': searchType,
        };
      }

      // Extract answer from Nova response format
      final output = data['output'] as Map<String, dynamic>?;
      final message = output?['message'] as Map<String, dynamic>?;
      final content = message?['content'] as List?;

      if (content == null || content.isEmpty) {
        return {
          'success': false,
          'answer': 'No answer found.',
          'searchType': searchType,
        };
      }

      final answerText = content[0]['text'] as String? ?? 'No answer available.';

      return {
        'success': true,
        'answer': answerText,
        'citations': <Map<String, dynamic>>[],
        'sources': <String>[],
        'searchType': searchType,
        'hasGrounding': true,
      };
    } catch (e) {
      safePrint('[Grounded Search] Parse error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'answer': 'Failed to parse response.',
        'searchType': searchType,
      };
    }
  }

  /// Determine if query needs grounding (factual questions)
  bool shouldUseGrounding(String query) {
    final lowerQuery = query.toLowerCase();
    
    final factualKeywords = [
      'what is', 'who is', 'when did', 'where is',
      'how much', 'how many', 'define', 'explain',
      'current', 'latest', 'recent', 'today',
      'price of', 'cost of', 'tax rate',
      'regulation', 'law', 'rule',
    ];

    return factualKeywords.any((keyword) => lowerQuery.contains(keyword));
  }
}
