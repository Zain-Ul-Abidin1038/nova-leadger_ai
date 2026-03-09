import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_ledger_ai/core/router/app_router.dart';
import 'package:nova_ledger_ai/core/theme/theme_provider.dart';

class NovaAccountantApp extends ConsumerWidget {
  const NovaAccountantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'NovaLedger AI',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
