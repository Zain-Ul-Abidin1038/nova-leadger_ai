import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_ledger_ai/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: GhostAccountantApp()));

    // Verify that the app loads
    await tester.pumpAndSettle();
    
    // Check for NovaLedger AI title
    expect(find.text('NovaLedger AI'), findsOneWidget);
  });
}
