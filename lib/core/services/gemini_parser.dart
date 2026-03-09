import 'dart:convert';

/// Response Parser Helpers
/// Extracts data from Nova API responses
class NovaParser {
  /// Extract text from response
  static Map<String, dynamic> extractText(Map<String, dynamic> response) {
    try {
      final candidates = response['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return <String, dynamic>{'text': '', 'error': 'No candidates in response'};
      }
      
      final content = candidates[0]['content'];
      final parts = content['parts'] as List;
      
      StringBuffer textOutput = StringBuffer();
      for (var part in parts) {
        if (part.containsKey('text')) {
          textOutput.write(part['text']);
        }
      }
      
      return <String, dynamic>{'text': textOutput.toString()};
    } catch (e) {
      return <String, dynamic>{'text': '', 'error': e.toString()};
    }
  }

  /// Extract JSON from response
  static Map<String, dynamic> extractJson(Map<String, dynamic> response) {
    try {
      final textResult = extractText(response);
      if (textResult.containsKey('error')) {
        throw Exception(textResult['error']);
      }
      
      final text = textResult['text'] as String;
      
      // If text is empty, throw error
      if (text.trim().isEmpty) {
        throw Exception('Empty response from API');
      }
      
      // Try to parse as JSON directly
      try {
        final trimmed = text.trim();
        return jsonDecode(trimmed) as Map<String, dynamic>;
      } catch (_) {
        // Try to extract JSON from markdown code blocks
        final jsonMatch = RegExp(r'```json\s*([\s\S]*?)\s*```').firstMatch(text);
        if (jsonMatch != null) {
          try {
            return jsonDecode(jsonMatch.group(1)!) as Map<String, dynamic>;
          } catch (e) {
            // Continue to next extraction method
          }
        }
        
        // Try to extract any JSON object (greedy match)
        final objectMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
        if (objectMatch != null) {
          try {
            return jsonDecode(objectMatch.group(0)!) as Map<String, dynamic>;
          } catch (e) {
            // Continue to next extraction method
          }
        }
        
        // Try to find first { and last } and extract that
        final firstBrace = text.indexOf('{');
        final lastBrace = text.lastIndexOf('}');
        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
          try {
            final jsonStr = text.substring(firstBrace, lastBrace + 1);
            return jsonDecode(jsonStr) as Map<String, dynamic>;
          } catch (e) {
            // Continue to error
          }
        }
        
        throw Exception('No valid JSON found in response. Text: ${text.substring(0, text.length > 200 ? 200 : text.length)}...');
      }
    } catch (e) {
      throw Exception('Failed to extract JSON: $e');
    }
  }

  /// Extract thought signature from response
  static String? extractThoughtSignature(Map<String, dynamic> response) {
    try {
      final candidates = response['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) return null;

      final parts = candidates[0]['content']['parts'] as List;
      for (final part in parts) {
        if (part['thoughtSignature'] != null) {
          return part['thoughtSignature'] as String;
        }
      }
    } catch (e) {
      // Signature extraction is optional
    }
    return null;
  }
  
  /// Extract usage metadata
  static Map<String, int> extractUsage(Map<String, dynamic> response) {
    try {
      final usage = response['usageMetadata'];
      if (usage == null) return <String, int>{};
      
      return <String, int>{
        'promptTokens': usage['promptTokenCount'] ?? 0,
        'outputTokens': usage['candidatesTokenCount'] ?? 0,
        'totalTokens': usage['totalTokenCount'] ?? 0,
      };
    } catch (e) {
      return <String, int>{};
    }
  }
}
