import 'package:flutter_riverpod/flutter_riverpod.dart';

final novaMemoryProvider = Provider((ref) => NovaMemory());

/// Thought Memory Store for reasoning continuity
/// Persists thought signatures across requests
class NovaMemory {
  String? lastThoughtSignature;
  
  final List<String> _conversationMemory = [];
  
  void addMemory(String memory) {
    _conversationMemory.add(memory);
    if (_conversationMemory.length > 10) {
      _conversationMemory.removeAt(0);
    }
  }
  
  List<String> getMemories() => List.from(_conversationMemory);
  
  void clearMemories() {
    _conversationMemory.clear();
    lastThoughtSignature = null;
  }
}
