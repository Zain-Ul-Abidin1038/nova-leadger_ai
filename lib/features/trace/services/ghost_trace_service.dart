import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ghostTraceProvider = StreamProvider<String>((ref) {
  return ref.watch(ghostTraceServiceProvider).traceStream;
});

final ghostTraceServiceProvider = Provider((ref) => NovaTraceService());

class NovaTraceService {
  final _controller = StreamController<String>.broadcast();
  Stream<String> get traceStream => _controller.stream;

  void addTrace(String trace) {
    _controller.add(trace);
  }
  
  void dispose() {
    _controller.close();
  }
}
