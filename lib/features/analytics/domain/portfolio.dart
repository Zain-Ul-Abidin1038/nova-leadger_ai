/// Portfolio Allocation
class PortfolioAllocation {
  final double stocks;
  final double bonds;
  final double cash;
  final double alternatives;

  PortfolioAllocation({
    required this.stocks,
    required this.bonds,
    required this.cash,
    required this.alternatives,
  });

  /// Validate allocation sums to 1.0
  bool get isValid {
    final sum = stocks + bonds + cash + alternatives;
    return (sum - 1.0).abs() < 0.01;
  }

  /// Get allocation for risk tolerance (0.0 = conservative, 1.0 = aggressive)
  factory PortfolioAllocation.forRiskTolerance(double riskTolerance) {
    if (riskTolerance < 0.3) {
      // Conservative
      return PortfolioAllocation(
        stocks: 0.30,
        bonds: 0.50,
        cash: 0.15,
        alternatives: 0.05,
      );
    } else if (riskTolerance < 0.7) {
      // Moderate
      return PortfolioAllocation(
        stocks: 0.60,
        bonds: 0.30,
        cash: 0.05,
        alternatives: 0.05,
      );
    } else {
      // Aggressive
      return PortfolioAllocation(
        stocks: 0.80,
        bonds: 0.10,
        cash: 0.05,
        alternatives: 0.05,
      );
    }
  }

  Map<String, double> toMap() => {
        'stocks': stocks,
        'bonds': bonds,
        'cash': cash,
        'alternatives': alternatives,
      };
}

/// Portfolio Position
class PortfolioPosition {
  final String symbol;
  final String assetClass;
  final double shares;
  final double currentPrice;
  final double totalValue;

  PortfolioPosition({
    required this.symbol,
    required this.assetClass,
    required this.shares,
    required this.currentPrice,
    required this.totalValue,
  });

  double get allocation => totalValue;
}

/// Portfolio
class Portfolio {
  final List<PortfolioPosition> positions;
  final double totalValue;
  final DateTime lastUpdated;

  Portfolio({
    required this.positions,
    required this.totalValue,
    required this.lastUpdated,
  });

  /// Get current allocation
  PortfolioAllocation getCurrentAllocation() {
    double stocks = 0;
    double bonds = 0;
    double cash = 0;
    double alternatives = 0;

    for (final position in positions) {
      final weight = position.totalValue / totalValue;
      switch (position.assetClass) {
        case 'stock':
        case 'equity':
          stocks += weight;
          break;
        case 'bond':
        case 'fixed_income':
          bonds += weight;
          break;
        case 'cash':
        case 'money_market':
          cash += weight;
          break;
        default:
          alternatives += weight;
      }
    }

    return PortfolioAllocation(
      stocks: stocks,
      bonds: bonds,
      cash: cash,
      alternatives: alternatives,
    );
  }

  /// Empty portfolio
  factory Portfolio.empty() {
    return Portfolio(
      positions: [],
      totalValue: 0,
      lastUpdated: DateTime.now(),
    );
  }
}

/// Rebalancing Action
class RebalancingAction {
  final String symbol;
  final String action; // 'buy' or 'sell'
  final double shares;
  final double estimatedValue;
  final String reason;

  RebalancingAction({
    required this.symbol,
    required this.action,
    required this.shares,
    required this.estimatedValue,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'action': action,
        'shares': shares,
        'estimatedValue': estimatedValue,
        'reason': reason,
      };
}
