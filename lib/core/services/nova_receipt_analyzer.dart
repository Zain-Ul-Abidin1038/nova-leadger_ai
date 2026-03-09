import 'dart:convert';
import 'package:http/http.dart' as http;

/// Nova Receipt Analyzer
/// Uses Nova multimodal capabilities for:
/// - Receipt OCR
/// - Expense classification
/// - Tax deduction detection
/// - Financial category mapping
class NovaReceiptAnalyzer {
  final String apiKey;
  final String region;
  static const String _baseUrl = 'https://bedrock-runtime';
  
  NovaReceiptAnalyzer({
    required this.apiKey,
    required this.region,
  });

  /// Analyze receipt image using Nova multimodal
  Future<Map<String, dynamic>> analyzeReceipt({
    required String base64Image,
    required String region,
  }) async {
    try {
      final endpoint = '$_baseUrl.${this.region}.amazonaws.com/model/amazon.nova-pro-v1:0/invoke';
      
      final requestBody = {
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'image': {
                  'format': 'jpeg',
                  'source': {
                    'bytes': base64Image,
                  }
                }
              },
              {
                'text': '''
Analyze this receipt and extract:
1. Vendor name
2. Date (YYYY-MM-DD)
3. Total amount
4. Currency
5. Line items with prices
6. Tax amount
7. Payment method
8. Category (dining, groceries, transportation, etc.)
9. Tax deductibility (percentage 0-100)
10. Deduction category (meals, travel, office supplies, etc.)

Region: $region

Return as JSON with this structure:
{
  "vendor": "string",
  "date": "YYYY-MM-DD",
  "total": number,
  "currency": "string",
  "items": [{"name": "string", "price": number}],
  "tax": number,
  "paymentMethod": "string",
  "category": "string",
  "taxDeductible": number,
  "deductionCategory": "string",
  "confidence": number
}
'''
              }
            ]
          }
        ],
        'inferenceConfig': {
          'temperature': 0.1,
          'maxTokens': 2048,
        },
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
        final resultText = data['output']['message']['content'][0]['text'];
        
        // Parse JSON from response
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(resultText);
        if (jsonMatch != null) {
          final receiptData = jsonDecode(jsonMatch.group(0)!);
          return {
            'success': true,
            'receipt': receiptData,
          };
        } else {
          return {
            'success': false,
            'error': 'Could not parse receipt data',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Nova receipt analysis error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Nova receipt analyzer error: $e',
      };
    }
  }

  /// Classify expense category
  Future<String> classifyExpense({
    required String description,
    required double amount,
  }) async {
    try {
      final endpoint = '$_baseUrl.$region.amazonaws.com/model/amazon.nova-lite-v1:0/invoke';
      
      final requestBody = {
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'text': '''
Classify this expense into one category:
Description: $description
Amount: \$$amount

Categories: dining, groceries, transportation, utilities, entertainment, healthcare, shopping, travel, education, other

Return only the category name.
'''
              }
            ]
          }
        ],
        'inferenceConfig': {
          'temperature': 0.1,
          'maxTokens': 50,
        },
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
        return data['output']['message']['content'][0]['text'].trim().toLowerCase();
      } else {
        return 'other';
      }
    } catch (e) {
      return 'other';
    }
  }

  /// Detect tax deductions
  Future<Map<String, dynamic>> detectTaxDeductions({
    required String category,
    required String description,
    required double amount,
  }) async {
    try {
      final endpoint = '$_baseUrl.$region.amazonaws.com/model/amazon.nova-lite-v1:0/invoke';
      
      final requestBody = {
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'text': '''
Determine tax deductibility for this expense:
Category: $category
Description: $description
Amount: \$$amount

Return JSON:
{
  "deductible": true/false,
  "percentage": 0-100,
  "deductionType": "string",
  "notes": "string"
}
'''
              }
            ]
          }
        ],
        'inferenceConfig': {
          'temperature': 0.1,
          'maxTokens': 256,
        },
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
        final resultText = data['output']['message']['content'][0]['text'];
        
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(resultText);
        if (jsonMatch != null) {
          return jsonDecode(jsonMatch.group(0)!);
        }
      }
      
      return {
        'deductible': false,
        'percentage': 0,
        'deductionType': 'none',
        'notes': 'Could not determine deductibility',
      };
    } catch (e) {
      return {
        'deductible': false,
        'percentage': 0,
        'deductionType': 'none',
        'notes': 'Error: $e',
      };
    }
  }

  /// Map to financial category
  Future<String> mapFinancialCategory({
    required String expenseCategory,
    required String description,
  }) async {
    final categoryMap = {
      'dining': 'Food & Dining',
      'groceries': 'Groceries',
      'transportation': 'Transportation',
      'utilities': 'Utilities',
      'entertainment': 'Entertainment',
      'healthcare': 'Healthcare',
      'shopping': 'Shopping',
      'travel': 'Travel',
      'education': 'Education',
      'other': 'Other',
    };
    
    return categoryMap[expenseCategory.toLowerCase()] ?? 'Other';
  }
}
