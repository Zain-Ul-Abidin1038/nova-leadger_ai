import 'package:flutter_riverpod/flutter_riverpod.dart';

final novaRouterProvider = Provider((ref) => NovaRouter());

/// Hybrid Model Router
/// Automatically selects Flash vs Pro based on workload
class NovaRouter {
  static const String flashModel = 'nova-3-flash-preview';
  static const String proModel = 'nova-3-pro-preview';
  
  RequestProfile selectProfile({
    required bool needsDeepReasoning,
    required bool isVision,
    required bool isParsing,
    bool isMultiTransaction = false,
  }) {
    // Deep reasoning tasks → Pro
    if (needsDeepReasoning) {
      return RequestProfile(
        model: proModel,
        thinkingLevel: 'high',
        maxTokens: 4096,
        description: 'Deep Reasoning (Pro)',
      );
    }
    
    // Vision tasks → Flash with medium thinking
    if (isVision) {
      return RequestProfile(
        model: flashModel,
        thinkingLevel: 'medium',
        maxTokens: 2048,
        description: 'Receipt Vision (Flash)',
      );
    }
    
    // Multi-transaction splitting → Higher token limit
    if (isMultiTransaction) {
      return RequestProfile(
        model: flashModel,
        thinkingLevel: 'low',
        maxTokens: 2048, // Increased for large arrays
        description: 'Multi-Transaction Split (Flash)',
      );
    }
    
    // Parsing tasks → Flash with low thinking
    if (isParsing) {
      return RequestProfile(
        model: flashModel,
        thinkingLevel: 'low',
        maxTokens: 512,
        description: 'Fast Parsing (Flash)',
      );
    }
    
    // Default: Fast chat
    return RequestProfile(
      model: flashModel,
      thinkingLevel: 'low',
      maxTokens: 512,
      description: 'Fast Chat (Flash)',
    );
  }
}

/// Request Profile for different workloads
class RequestProfile {
  final String model;
  final String thinkingLevel;
  final int maxTokens;
  final String description;
  
  RequestProfile({
    required this.model,
    required this.thinkingLevel,
    required this.maxTokens,
    required this.description,
  });
  
  Map<String, dynamic> buildGenerationConfig({
    String? responseMimeType,
    Map<String, dynamic>? responseJsonSchema,
  }) {
    final config = <String, dynamic>{
      'thinkingConfig': <String, dynamic>{'thinkingLevel': thinkingLevel},
      'maxOutputTokens': maxTokens,
      'temperature': 1.0,
      'topP': 0.95,
      'topK': 64,
    };
    
    if (responseMimeType != null) {
      config['responseMimeType'] = responseMimeType;
    }
    
    if (responseJsonSchema != null) {
      config['responseJsonSchema'] = responseJsonSchema;
    }
    
    return config;
  }
}
