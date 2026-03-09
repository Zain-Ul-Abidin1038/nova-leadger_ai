import '../domain/financial_context.dart';
import '../domain/agent_result.dart';

/// Financial Agent Interface
/// Base interface for all specialized financial agents
abstract class FinancialAgent {
  String get name;
  String get type;
  
  /// Analyze financial context and return insights
  Future<AgentResult> analyze(FinancialContext context);
  
  /// Get agent priority (1-10, higher = more important)
  int get priority;
  
  /// Check if agent should run for this context
  bool shouldRun(FinancialContext context);
}


/// Health Agent
/// Monitors overall financial health
class HealthAgent implements FinancialAgent {
  @override
  String get name => 'Health Monitor';
  
  @override
  String get type => 'health';
  
  @override
  int get priority => 10;
  
  @override
  bool shouldRun(FinancialContext context) => true;
  
  @override
  Future<AgentResult> analyze(FinancialContext context) async {
    final snapshot = context.snapshot;
    final twin = context.twin;
    
    // Calculate health metrics
    final savingsRate = twin.savingsRate;
    final emergencyFundMonths = snapshot.balance / snapshot.monthlyExpenses;
    final debtToIncome = 0.0; // TODO: Calculate from debt data
    
    // Health score (0-100)
    double healthScore = 0;
    healthScore += (savingsRate * 100) * 0.3; // 30% weight
    healthScore += (emergencyFundMonths.clamp(0, 6) / 6 * 100) * 0.4; // 40% weight
    healthScore += ((1 - debtToIncome) * 100) * 0.3; // 30% weight
    
    final recommendations = <String>[];
    if (savingsRate < 0.2) {
      recommendations.add('Increase savings rate to at least 20%');
    }
    if (emergencyFundMonths < 3) {
      recommendations.add('Build emergency fund to 3-6 months of expenses');
    }
    
    return AgentResult(
      agentName: name,
      agentType: type,
      confidence: 0.95,
      insights: {
        'healthScore': healthScore,
        'savingsRate': savingsRate,
        'emergencyFundMonths': emergencyFundMonths,
        'debtToIncome': debtToIncome,
      },
      recommendations: recommendations,
    );
  }
}

/// Risk Agent
/// Assesses financial risk exposure
class RiskAgent implements FinancialAgent {
  @override
  String get name => 'Risk Assessor';
  
  @override
  String get type => 'risk';
  
  @override
  int get priority => 9;
  
  @override
  bool shouldRun(FinancialContext context) => true;
  
  @override
  Future<AgentResult> analyze(FinancialContext context) async {
    final twin = context.twin;
    final snapshot = context.snapshot;
    
    // Risk dimensions
    final liquidityRisk = _calculateLiquidityRisk(snapshot);
    final volatilityRisk = _calculateVolatilityRisk(context);
    final concentrationRisk = _calculateConcentrationRisk(context);
    
    // Overall risk (weighted average)
    final overallRisk = (liquidityRisk * 0.4) +
        (volatilityRisk * 0.3) +
        (concentrationRisk * 0.3);
    
    final recommendations = <String>[];
    if (liquidityRisk > 0.7) {
      recommendations.add('Increase liquid emergency fund');
    }
    if (volatilityRisk > 0.6) {
      recommendations.add('Reduce spending volatility');
    }
    
    return AgentResult(
      agentName: name,
      agentType: type,
      confidence: 0.88,
      insights: {
        'overallRisk': overallRisk,
        'liquidityRisk': liquidityRisk,
        'volatilityRisk': volatilityRisk,
        'concentrationRisk': concentrationRisk,
        'riskLevel': _getRiskLevel(overallRisk),
      },
      recommendations: recommendations,
    );
  }
  
  double _calculateLiquidityRisk(snapshot) {
    final months = snapshot.balance / snapshot.monthlyExpenses;
    if (months >= 6) return 0.1;
    if (months >= 3) return 0.3;
    if (months >= 1) return 0.6;
    return 0.9;
  }
  
  double _calculateVolatilityRisk(FinancialContext context) {
    // TODO: Calculate from transaction history
    return 0.3;
  }
  
  double _calculateConcentrationRisk(FinancialContext context) {
    // TODO: Calculate from income/expense sources
    return 0.2;
  }
  
  String _getRiskLevel(double risk) {
    if (risk < 0.3) return 'Low';
    if (risk < 0.6) return 'Moderate';
    return 'High';
  }
}


/// Tax Agent
/// Identifies tax optimization opportunities
class TaxAgent implements FinancialAgent {
  @override
  String get name => 'Tax Optimizer';
  
  @override
  String get type => 'tax';
  
  @override
  int get priority => 8;
  
  @override
  bool shouldRun(FinancialContext context) => true;
  
  @override
  Future<AgentResult> analyze(FinancialContext context) async {
    final profile = context.profile;
    
    // Calculate deductions
    double totalDeductions = 0;
    for (final receipt in profile.receipts) {
      totalDeductions += receipt.deductibleAmount;
    }
    
    // Estimate tax savings
    final taxRate = 0.30; // 30% tax bracket assumption
    final estimatedSavings = totalDeductions * taxRate;
    
    final recommendations = <String>[];
    if (totalDeductions < profile.snapshot.monthlyExpenses * 0.3) {
      recommendations.add('Track more business expenses for deductions');
    }
    recommendations.add('Review quarterly tax estimates');
    
    return AgentResult(
      agentName: name,
      agentType: type,
      confidence: 0.92,
      insights: {
        'totalDeductions': totalDeductions,
        'estimatedSavings': estimatedSavings,
        'effectiveTaxRate': taxRate,
        'receiptCount': profile.receipts.length,
      },
      recommendations: recommendations,
    );
  }
}

/// Goal Agent
/// Tracks progress toward financial goals
class GoalAgent implements FinancialAgent {
  @override
  String get name => 'Goal Tracker';
  
  @override
  String get type => 'goal';
  
  @override
  int get priority => 7;
  
  @override
  bool shouldRun(FinancialContext context) => true;
  
  @override
  Future<AgentResult> analyze(FinancialContext context) async {
    final twin = context.twin;
    
    // TODO: Load actual goals from storage
    final goals = <Map<String, dynamic>>[];
    
    final recommendations = <String>[];
    if (twin.savingsRate > 0.2) {
      recommendations.add('Consider setting up automatic goal contributions');
    }
    
    return AgentResult(
      agentName: name,
      agentType: type,
      confidence: 0.85,
      insights: {
        'activeGoals': goals.length,
        'totalProgress': 0.0,
        'onTrackCount': 0,
        'behindCount': 0,
      },
      recommendations: recommendations,
    );
  }
}

/// Cashflow Agent
/// Predicts future cashflow
class CashflowAgent implements FinancialAgent {
  @override
  String get name => 'Cashflow Predictor';
  
  @override
  String get type => 'cashflow';
  
  @override
  int get priority => 8;
  
  @override
  bool shouldRun(FinancialContext context) => true;
  
  @override
  Future<AgentResult> analyze(FinancialContext context) async {
    final twin = context.twin;
    
    // Simple 30-day projection
    final projectedBalance = twin.projectNetWorth(1);
    final netChange = projectedBalance - twin.balance;
    
    final recommendations = <String>[];
    if (netChange < 0) {
      recommendations.add('Projected negative cashflow - review expenses');
    }
    
    return AgentResult(
      agentName: name,
      agentType: type,
      confidence: 0.87,
      insights: {
        'currentBalance': twin.balance,
        'projectedBalance': projectedBalance,
        'netChange': netChange,
        'trend': netChange >= 0 ? 'positive' : 'negative',
      },
      recommendations: recommendations,
    );
  }
}
