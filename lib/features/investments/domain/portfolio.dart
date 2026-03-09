import 'investment.dart';

class Portfolio {
  final String id;
  final String userId;
  final String name;
  final List<Investment> investments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Portfolio({
    required this.id,
    required this.userId,
    required this.name,
    required this.investments,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalInvested {
    return investments.fold(0.0, (sum, inv) => sum + inv.totalInvested);
  }

  double get currentValue {
    return investments.fold(0.0, (sum, inv) => sum + inv.currentValue);
  }

  double get totalProfitLoss => currentValue - totalInvested;

  double get totalProfitLossPercentage {
    if (totalInvested == 0) return 0.0;
    return (totalProfitLoss / totalInvested) * 100;
  }

  bool get isProfit => totalProfitLoss >= 0;

  Map<InvestmentType, double> get allocationByType {
    final allocation = <InvestmentType, double>{};
    for (final investment in investments) {
      allocation[investment.type] = 
          (allocation[investment.type] ?? 0.0) + investment.currentValue;
    }
    return allocation;
  }

  Map<InvestmentType, double> get allocationPercentageByType {
    final allocation = allocationByType;
    final total = currentValue;
    if (total == 0) return {};
    
    return allocation.map((type, value) => MapEntry(type, (value / total) * 100));
  }

  List<Investment> get topPerformers {
    final sorted = List<Investment>.from(investments)
      ..sort((a, b) => b.profitLossPercentage.compareTo(a.profitLossPercentage));
    return sorted.take(5).toList();
  }

  List<Investment> get worstPerformers {
    final sorted = List<Investment>.from(investments)
      ..sort((a, b) => a.profitLossPercentage.compareTo(b.profitLossPercentage));
    return sorted.take(5).toList();
  }

  Portfolio copyWith({
    String? id,
    String? userId,
    String? name,
    List<Investment>? investments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Portfolio(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      investments: investments ?? this.investments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'investments': investments.map((i) => i.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      investments: (json['investments'] as List)
          .map((i) => Investment.fromJson(i as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
