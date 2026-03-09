import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final novaTraceProvider = StreamProvider<String>((ref) {
  return ref.watch(novaTraceServiceProvider).traceStream;
});

final novaTraceServiceProvider = Provider((ref) => NovaTraceService());

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
