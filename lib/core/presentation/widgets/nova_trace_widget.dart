import 'package:flutter/material.dart';

// The "Nova Trace" Terminal Widget
class NovaTraceWidget extends StatelessWidget {
  final String currentThought;

  const NovaTraceWidget({super.key, required this.currentThought});

  @override
  Widget build(BuildContext context) {
    if (currentThought.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.psychology, color: Colors.tealAccent, size: 16),
              SizedBox(width: 8),
              Text("REASONING TRACE (LEVEL: HIGH)", 
                   style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(color: Colors.tealAccent.withOpacity(0.3)),
          Text(
            currentThought,
            style: const TextStyle(color: Colors.white70, fontFamily: 'Courier', fontSize: 12),
          ),
        ],
      ),
    );
  }
}
