/// Cashflow Prediction Point
/// Represents predicted balance at a future date
class CashflowPoint {
  final int day;
  final double predictedBalance;
  final double confidence; // 0-1

  CashflowPoint({
    required this.day,
    required this.predictedBalance,
    this.confidence = 0.8,
  });

  bool get isNegative => predictedBalance < 0;
  bool get isLowBalance => predictedBalance < 100;

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'predictedBalance': predictedBalance,
      'confidence': confidence,
    };
  }

  factory CashflowPoint.fromJson(Map<String, dynamic> json) {
    return CashflowPoint(
      day: json['day'] as int,
      predictedBalance: (json['predictedBalance'] as num).toDouble(),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.8,
    );
  }
}
