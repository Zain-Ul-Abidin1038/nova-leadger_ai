import 'package:flutter_riverpod/flutter_riverpod.dart';

final novaValidatorProvider = Provider((ref) => NovaResponseValidator());

/// AI Response Validator
/// Prevents bad data from entering the database
class NovaResponseValidator {
  void validateText(Map<String, dynamic> response) {
    if (response['candidates'] == null || (response['candidates'] as List).isEmpty) {
      throw Exception('Invalid Nova response: no candidates');
    }
    
    final content = response['candidates'][0]['content'];
    if (content == null) {
      throw Exception('Invalid Nova response: no content');
    }
    
    final parts = content['parts'];
    if (parts == null || (parts as List).isEmpty) {
      throw Exception('Invalid Nova response: no parts');
    }
  }

  void validateReceipt(Map<String, dynamic> json) {
    if (!json.containsKey('vendor')) {
      throw Exception('Receipt missing vendor');
    }

    if (!json.containsKey('total')) {
      throw Exception('Receipt missing total');
    }
    
    final total = json['total'];
    if (total is! num || total < 0) {
      throw Exception('Receipt has invalid total: $total');
    }

    final confidence = json['confidence'] ?? 1.0;
    if (confidence < 0.6) {
      throw Exception('Low confidence receipt: $confidence');
    }
  }
  
  void validateFinanceCommand(Map<String, dynamic> json) {
    if (!json.containsKey('action')) {
      throw Exception('Finance command missing action');
    }
    
    final action = json['action'];
    final validActions = [
      'add_expense',
      'add_income',
      'add_loan_given',
      'add_loan_received',
      'mark_paid',
      'query',
      'unknown'
    ];
    
    if (!validActions.contains(action)) {
      throw Exception('Invalid action: $action');
    }
  }
  
  /// Check if receipt requires manual review
  bool requiresManualReview(Map<String, dynamic> receipt) {
    final confidence = receipt['confidence'] ?? 0.0;
    final total = receipt['total'] ?? 0;

    if (confidence < 0.75) return true;
    if (total <= 0) return true;
    
    // Check for missing critical fields
    if (receipt['vendor'] == null || receipt['vendor'] == 'Unknown') return true;
    if (receipt['category'] == null || receipt['category'] == 'Unknown') return true;

    return false;
  }
}
