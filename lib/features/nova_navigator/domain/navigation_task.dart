enum TaskStatus {
  planning,
  analyzing,
  executing,
  completed,
  failed,
}

enum ActionType {
  click,
  input,
  scroll,
  wait,
  navigate,
  extract,
}

class NavigationTask {
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<NavigationStep> steps;
  final Map<String, dynamic>? result;
  final String? error;

  NavigationTask({
    required this.description,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.steps = const [],
    this.result,
    this.error,
  });

  NavigationTask copyWith({
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    List<NavigationStep>? steps,
    Map<String, dynamic>? result,
    String? error,
  }) {
    return NavigationTask(
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      steps: steps ?? this.steps,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

class NavigationStep {
  final ActionType action;
  final String description;
  final Map<String, dynamic> parameters;
  final DateTime executedAt;
  final bool success;
  final String? error;

  NavigationStep({
    required this.action,
    required this.description,
    required this.parameters,
    required this.executedAt,
    this.success = true,
    this.error,
  });
}

class UIElement {
  final String type; // button, input, link, etc.
  final String? text;
  final String? id;
  final String? className;
  final Map<String, double> bounds; // x, y, width, height
  final bool isClickable;
  final bool isVisible;

  UIElement({
    required this.type,
    this.text,
    this.id,
    this.className,
    required this.bounds,
    this.isClickable = false,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'id': id,
      'className': className,
      'bounds': bounds,
      'isClickable': isClickable,
      'isVisible': isVisible,
    };
  }
}

class ScreenAnalysis {
  final List<UIElement> elements;
  final String screenType; // login, search, checkout, etc.
  final String description;
  final List<String> possibleActions;
  final DateTime analyzedAt;

  ScreenAnalysis({
    required this.elements,
    required this.screenType,
    required this.description,
    required this.possibleActions,
    required this.analyzedAt,
  });
}
