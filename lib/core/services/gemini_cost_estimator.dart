import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

final novaCostEstimatorProvider = Provider((ref) => NovaCostEstimator());

/// Cost Estimator for Nova API usage
/// Tracks approximate costs based on token usage
class NovaCostEstimator {
  double totalCost = 0;
  int totalRequests = 0;
  
  // Nova 3 Flash pricing (approximate)
  static const double inputCostPerToken = 0.00000015;  // $0.15 per 1M tokens
  static const double outputCostPerToken = 0.0000006;  // $0.60 per 1M tokens

  void record(Map<String, dynamic> response) {
    final usage = response['usageMetadata'];
    if (usage == null) return;

    final inputTokens = usage['promptTokenCount'] ?? 0;
    final outputTokens = usage['candidatesTokenCount'] ?? 0;

    final cost = (inputTokens * inputCostPerToken) + 
                 (outputTokens * outputCostPerToken);

    totalCost += cost;
    totalRequests++;

    safePrint('[Nova] Cost: \$${cost.toStringAsFixed(6)} (Total: \$${totalCost.toStringAsFixed(4)})');
  }
  
  Map<String, dynamic> getSummary() {
    return {
      'totalCost': totalCost,
      'totalRequests': totalRequests,
      'averageCostPerRequest': totalRequests > 0 ? totalCost / totalRequests : 0,
    };
  }
  
  void reset() {
    totalCost = 0;
    totalRequests = 0;
  }
}
