import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

final aiMetricsProvider = Provider((ref) => AIMetricsService());

/// AI Telemetry and Observability
/// 
/// Tracks AI health like a real SaaS:
/// - Request count
/// - Failure rate
/// - Latency
/// - Token usage
/// - Cost
/// - Fallback rate
/// - Review rate
class AIMetricsService {
  final AIMetrics metrics = AIMetrics();

  void recordSuccess({
    required int tokens,
    required double cost,
    required int latencyMs,
  }) {
    metrics.requests++;
    metrics.totalTokens += tokens;
    metrics.totalCost += cost;
    metrics.totalLatency += latencyMs;

    safePrint('[AIMetrics] Success recorded');
    safePrint('[AIMetrics] Total requests: ${metrics.requests}');
    safePrint('[AIMetrics] Total cost: \$${metrics.totalCost.toStringAsFixed(4)}');
  }

  void recordFailure() {
    metrics.failures++;
    safePrint('[AIMetrics] Failure recorded (${metrics.failures} total)');
  }

  void recordFallback() {
    metrics.fallbacks++;
    safePrint('[AIMetrics] Fallback used (${metrics.fallbacks} total)');
  }

  void recordManualReview() {
    metrics.manualReviews++;
    safePrint('[AIMetrics] Manual review required (${metrics.manualReviews} total)');
  }

  void recordAutoApproval() {
    metrics.autoApprovals++;
    safePrint('[AIMetrics] Auto-approved (${metrics.autoApprovals} total)');
  }

  void recordAnomalyDetected() {
    metrics.anomaliesDetected++;
    safePrint('[AIMetrics] Anomaly detected (${metrics.anomaliesDetected} total)');
  }

  /// Get success rate percentage
  double getSuccessRate() {
    if (metrics.requests == 0) return 100.0;
    final successCount = metrics.requests - metrics.failures;
    return (successCount / metrics.requests) * 100;
  }

  /// Get fallback rate percentage
  double getFallbackRate() {
    if (metrics.requests == 0) return 0.0;
    return (metrics.fallbacks / metrics.requests) * 100;
  }

  /// Get manual review rate percentage
  double getReviewRate() {
    final totalReceipts = metrics.manualReviews + metrics.autoApprovals;
    if (totalReceipts == 0) return 0.0;
    return (metrics.manualReviews / totalReceipts) * 100;
  }

  /// Get auto-approval rate percentage
  double getAutoApprovalRate() {
    final totalReceipts = metrics.manualReviews + metrics.autoApprovals;
    if (totalReceipts == 0) return 0.0;
    return (metrics.autoApprovals / totalReceipts) * 100;
  }

  /// Get average latency in milliseconds
  double getAverageLatency() {
    if (metrics.requests == 0) return 0.0;
    return metrics.totalLatency / metrics.requests;
  }

  /// Get average cost per request
  double getAverageCost() {
    if (metrics.requests == 0) return 0.0;
    return metrics.totalCost / metrics.requests;
  }

  /// Get average tokens per request
  double getAverageTokens() {
    if (metrics.requests == 0) return 0.0;
    return metrics.totalTokens / metrics.requests;
  }

  /// Get dashboard summary
  Map<String, dynamic> getDashboardSummary() {
    return {
      'requests': metrics.requests,
      'failures': metrics.failures,
      'fallbacks': metrics.fallbacks,
      'manualReviews': metrics.manualReviews,
      'autoApprovals': metrics.autoApprovals,
      'anomaliesDetected': metrics.anomaliesDetected,
      'totalCost': metrics.totalCost,
      'totalTokens': metrics.totalTokens,
      'totalLatency': metrics.totalLatency,
      'successRate': getSuccessRate(),
      'fallbackRate': getFallbackRate(),
      'reviewRate': getReviewRate(),
      'autoApprovalRate': getAutoApprovalRate(),
      'averageLatency': getAverageLatency(),
      'averageCost': getAverageCost(),
      'averageTokens': getAverageTokens(),
    };
  }

  /// Reset all metrics
  void reset() {
    metrics.requests = 0;
    metrics.failures = 0;
    metrics.fallbacks = 0;
    metrics.manualReviews = 0;
    metrics.autoApprovals = 0;
    metrics.anomaliesDetected = 0;
    metrics.totalCost = 0;
    metrics.totalTokens = 0;
    metrics.totalLatency = 0;
    safePrint('[AIMetrics] Metrics reset');
  }

  /// Get health status
  String getHealthStatus() {
    final successRate = getSuccessRate();
    final fallbackRate = getFallbackRate();

    if (successRate >= 95 && fallbackRate < 5) {
      return 'Healthy';
    } else if (successRate >= 85 && fallbackRate < 15) {
      return 'Degraded';
    } else {
      return 'Unhealthy';
    }
  }
}

/// AI Metrics Data Model
class AIMetrics {
  int requests = 0;
  int failures = 0;
  int fallbacks = 0;
  int manualReviews = 0;
  int autoApprovals = 0;
  int anomaliesDetected = 0;
  double totalCost = 0;
  int totalTokens = 0;
  int totalLatency = 0; // in milliseconds
}
