import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/user_financial_profile.dart';
import '../domain/life_event.dart';

final lifeEventPredictorProvider = Provider((ref) => LifeEventPredictor());

/// Life Event Predictor
/// Detects major financial transitions early using pattern analysis
class LifeEventPredictor {
  static const String _boxName = 'life_events';
  Box<LifeEvent>? _box;
  final _uuid = const Uuid();

  Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(LifeEventAdapter());
    }
    _box = await Hive.openBox<LifeEvent>(_boxName);
  }

  /// Detect life events from financial profile
  List<LifeEvent> detect(UserFinancialProfile profile) {
    safePrint('[LifeEventPredictor] Analyzing profile...');
    
    final events = <LifeEvent>[];

    // Income changes
    events.addAll(_detectIncomeChanges(profile));

    // Spending patterns
    events.addAll(_detectSpendingPatterns(profile));

    // Milestones
    events.addAll(_detectMilestones(profile));

    safePrint('[LifeEventPredictor] Detected ${events.length} events');
    return events;
  }

  List<LifeEvent> _detectIncomeChanges(UserFinancialProfile profile) {
    final events = <LifeEvent>[];

    if (profile.snapshot.monthlyIncome > 
        profile.previousSnapshot.monthlyIncome * 1.3) {
      events.add(_createEvent(
        type: LifeEventType.incomeIncrease,
        description: 'Income increased significantly',
        confidence: 0.9,
      ));
    }

    return events;
  }

  List<LifeEvent> _detectSpendingPatterns(UserFinancialProfile profile) {
    final events = <LifeEvent>[];

    if (profile.anomalyFrequency > 5) {
      events.add(_createEvent(
        type: LifeEventType.financialStressRisk,
        description: 'High anomaly frequency detected',
        confidence: 0.75,
      ));
    }

    return events;
  }

  List<LifeEvent> _detectMilestones(UserFinancialProfile profile) {
    final events = <LifeEvent>[];

    if (profile.snapshot.runwayMonths >= 12) {
      events.add(_createEvent(
        type: LifeEventType.financialSecurityMilestone,
        description: 'Financial security milestone reached',
        confidence: 1.0,
      ));
    }

    return events;
  }

  LifeEvent _createEvent({
    required String type,
    required String description,
    required double confidence,
  }) {
    return LifeEvent(
      id: _uuid.v4(),
      type: type,
      description: description,
      detectedAt: DateTime.now(),
      confidence: confidence,
    );
  }

  Future<void> storeEvents(List<LifeEvent> events) async {
    for (final event in events) {
      await _box?.put(event.id, event);
    }
  }

  List<LifeEvent> getAllEvents() {
    return _box?.values.toList() ?? [];
  }
}
