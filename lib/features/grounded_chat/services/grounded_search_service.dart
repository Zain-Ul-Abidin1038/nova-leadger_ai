import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

final groundedSearchServiceProvider = Provider((ref) => GroundedSearchService());

/// Grounded Search Service - Provides factual answers using Vertex AI Search
/// 
/// Features:
/// - Web search grounding for real-time facts
/// - Document search using Vertex AI Search datastores
/// - Citation tracking for transparency
/// - Confidence scoring for answers
class GroundedSearchService {
  static String get _apiKey {
    try {
      final key = dotenv.env['GEMINI_API_KEY'];
      if (key != null && key.isNotEmpty) return key;
    } catch (e) {
      safePrint('[Grounded Search] dotenv not loaded: $e');
    }
    return const String.fromEnvironment(
      'GEMINI_API_KEY',
      defaultValue: 'AIzaSyA10HbjmIeRuQ_1CxV7cZrfEeb5JXn91Ms',
    );
  }

  static String get _projectId {
    return dotenv.env['GCP_PROJECT_ID'] ?? 'your-project-id';
  }

  static String get _datastoreId {
    return dotenv.env['VERTEX_DATASTORE_ID'] ?? 'your-datastore-id';
  }

  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  /// Search with web grounding - uses Google Search for real-time facts
  Future<Map<String, dynamic>> searchWithWebGrounding({
    required String query,
    String? context,
  }) async {
    try {
      safePrint('[Grounded Search] Web search: $query');

      final prompt = context != null
          ? '$context\n\nUser question: $query'
          : query;

      final request = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'tools': [
          {
            'googleSearchRetrieval': {
              'dynamicRetrievalConfig': {
                'mode': 'MODE_DYNAMIC',
                'dynamicThreshold': 0.7, // Confidence threshold
              }
            }
          }
        ],
        'generationConfig': {
          'temperature': 0.2, // Lower temperature for factual responses
          'topP': 0.8,
          'topK': 40,
          'maxOutputTokens': 2048,
        },
      };

      final response = await _postRequest('nova-1.5-flash-002', request);

      return _parseGroundedResponse(response, 'web');
    } catch (e) {
      safePrint('[Grounded Search] Web search error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'answer': 'I encountered an error searching for that information.',
      };
    }
  }

  /// Search with document grounding - uses Vertex AI Search datastore
  Future<Map<String, dynamic>> searchWithDocumentGrounding({
    required String query,
    String? context,
    String? datastoreId,
  }) async {
    try {
      safePrint('[Grounded Search] Document search: $query');

      final datastore = datastoreId ?? _datastoreId;
      final prompt = context != null
          ? '$context\n\nUser question: $query'
          : query;

      final request = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'tools': [
          {
            'retrieval': {
              'vertexAiSearch': {
                'datastore': 'projects/$_projectId/locations/global/collections/default_collection/dataStores/$datastore',
              },
              'disableAttribution': false,
            }
          }
        ],
        'generationConfig': {
          'temperature': 0.2,
          'topP': 0.8,
          'topK': 40,
          'maxOutputTokens': 2048,
        },
      };

      final response = await _postRequest('nova-1.5-pro-002', request);

      return _parseGroundedResponse(response, 'document');
    } catch (e) {
      safePrint('[Grounded Search] Document search error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'answer': 'I encountered an error searching the documents.',
      };
    }
  }

  /// Hybrid search - combines web and document grounding
  Future<Map<String, dynamic>> hybridSearch({
    required String query,
    String? context,
    String? datastoreId,
  }) async {
    try {
      safePrint('[Grounded Search] Hybrid search: $query');

      final datastore = datastoreId ?? _datastoreId;
      final prompt = context != null
          ? '$context\n\nUser question: $query'
          : query;

      final request = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'tools': [
          {
            'googleSearchRetrieval': {
              'dynamicRetrievalConfig': {
                'mode': 'MODE_DYNAMIC',
                'dynamicThreshold': 0.7,
              }
            }
          },
          {
            'retrieval': {
              'vertexAiSearch': {
                'datastore': 'projects/$_projectId/locations/global/collections/default_collection/dataStores/$datastore',
              },
              'disableAttribution': false,
            }
          }
        ],
        'generationConfig': {
          'temperature': 0.2,
          'topP': 0.8,
          'topK': 40,
          'maxOutputTokens': 2048,
        },
      };

      final response = await _postRequest('nova-1.5-pro-002', request);

      return _parseGroundedResponse(response, 'hybrid');
    } catch (e) {
      safePrint('[Grounded Search] Hybrid search error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'answer': 'I encountered an error searching for that information.',
      };
    }
  }

  /// Parse grounded response with citations
  Map<String, dynamic> _parseGroundedResponse(
    Map<String, dynamic> response,
    String searchType,
  ) {
    try {
      final candidates = response['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return {
          'success': false,
          'answer': 'No answer found.',
          'searchType': searchType,
        };
      }

      final candidate = candidates[0] as Map<String, dynamic>;
      final content = candidate['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;

      if (parts == null || parts.isEmpty) {
        return {
          'success': false,
          'answer': 'No answer found.',
          'searchType': searchType,
        };
      }

      // Extract answer text
      final answerText = parts[0]['text'] as String? ?? 'No answer available.';

      // Extract grounding metadata
      final groundingMetadata = candidate['groundingMetadata'] as Map<String, dynamic>?;
      final citations = <Map<String, dynamic>>[];
      final sources = <String>[];

      if (groundingMetadata != null) {
        // Extract grounding chunks (sources)
        final groundingChunks = groundingMetadata['groundingChunks'] as List?;
        if (groundingChunks != null) {
          for (final chunk in groundingChunks) {
            final web = chunk['web'] as Map<String, dynamic>?;
            if (web != null) {
              final uri = web['uri'] as String?;
              final title = web['title'] as String?;
              if (uri != null) {
                sources.add(uri);
                citations.add({
                  'url': uri,
                  'title': title ?? 'Source',
                  'type': 'web',
                });
              }
            }
          }
        }

        // Extract grounding supports (confidence) - reserved for future use
        // final groundingSupports = groundingMetadata['groundingSupports'] as List?;
      }

      return {
        'success': true,
        'answer': answerText,
        'citations': citations,
        'sources': sources,
        'searchType': searchType,
        'hasGrounding': citations.isNotEmpty,
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

  /// Make HTTP POST request to Nova API
  Future<Map<String, dynamic>> _postRequest(
    String model,
    Map<String, dynamic> requestBody,
  ) async {
    final url = Uri.parse('$_baseUrl/$model:generateContent?key=$_apiKey');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(requestBody);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('API error ${response.statusCode}: ${response.body}');
    }
  }

  /// Determine if query needs grounding (factual questions)
  bool shouldUseGrounding(String query) {
    final lowerQuery = query.toLowerCase();
    
    // Keywords that indicate factual questions
    final factualKeywords = [
      'what is',
      'who is',
      'when did',
      'where is',
      'how much',
      'how many',
      'define',
      'explain',
      'current',
      'latest',
      'recent',
      'today',
      'price of',
      'cost of',
      'tax rate',
      'regulation',
      'law',
      'rule',
    ];

    return factualKeywords.any((keyword) => lowerQuery.contains(keyword));
  }
}
