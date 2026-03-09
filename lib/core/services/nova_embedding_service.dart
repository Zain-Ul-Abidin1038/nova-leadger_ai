import 'dart:convert';
import 'package:http/http.dart' as http;

/// Nova Multimodal Embeddings Service
/// Replaces Vertex AI Search with Nova embeddings for:
/// - Financial knowledge retrieval
/// - Tax policy search
/// - Receipt similarity search
/// - Memory retrieval
/// - Document search
class NovaEmbeddingService {
  final String apiKey;
  final String region;
  static const String _baseUrl = 'https://bedrock-runtime';
  
  NovaEmbeddingService({
    required this.apiKey,
    required this.region,
  });

  /// Generate embeddings for text using Nova
  Future<List<double>> generateEmbedding(String text) async {
    try {
      final endpoint = '$_baseUrl.$region.amazonaws.com/model/amazon.titan-embed-text-v2:0/invoke';
      
      final requestBody = {
        'inputText': text,
        'dimensions': 1024,
        'normalize': true,
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
        return List<double>.from(data['embedding']);
      } else {
        throw Exception('Nova embedding error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Nova embedding service error: $e');
    }
  }

  /// Search financial knowledge base using embeddings
  Future<List<Map<String, dynamic>>> searchFinancialKnowledge({
    required String query,
    required List<Map<String, dynamic>> knowledgeBase,
    int topK = 5,
  }) async {
    try {
      // Generate query embedding
      final queryEmbedding = await generateEmbedding(query);
      
      // Calculate similarity scores
      final results = <Map<String, dynamic>>[];
      for (final doc in knowledgeBase) {
        final docEmbedding = doc['embedding'] as List<double>;
        final similarity = _cosineSimilarity(queryEmbedding, docEmbedding);
        
        results.add({
          ...doc,
          'similarity': similarity,
        });
      }
      
      // Sort by similarity and return top K
      results.sort((a, b) => (b['similarity'] as double).compareTo(a['similarity'] as double));
      return results.take(topK).toList();
    } catch (e) {
      throw Exception('Knowledge search error: $e');
    }
  }

  /// Search tax policies using embeddings
  Future<List<Map<String, dynamic>>> searchTaxPolicies({
    required String query,
    required List<Map<String, dynamic>> policies,
  }) async {
    return await searchFinancialKnowledge(
      query: query,
      knowledgeBase: policies,
      topK: 3,
    );
  }

  /// Find similar receipts using embeddings
  Future<List<Map<String, dynamic>>> findSimilarReceipts({
    required String receiptDescription,
    required List<Map<String, dynamic>> receipts,
  }) async {
    return await searchFinancialKnowledge(
      query: receiptDescription,
      knowledgeBase: receipts,
      topK: 5,
    );
  }

  /// Retrieve relevant memories using embeddings
  Future<List<Map<String, dynamic>>> retrieveMemories({
    required String context,
    required List<Map<String, dynamic>> memories,
  }) async {
    return await searchFinancialKnowledge(
      query: context,
      knowledgeBase: memories,
      topK: 3,
    );
  }

  /// Search documents using embeddings
  Future<List<Map<String, dynamic>>> searchDocuments({
    required String query,
    required List<Map<String, dynamic>> documents,
  }) async {
    return await searchFinancialKnowledge(
      query: query,
      knowledgeBase: documents,
      topK: 10,
    );
  }

  /// Calculate cosine similarity between two vectors
  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must have same length');
    }
    
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    
    return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
  }
}

class Math {
  static double sqrt(double x) => x < 0 ? 0 : x == 0 ? 0 : _sqrt(x);
  
  static double _sqrt(double x) {
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
}
