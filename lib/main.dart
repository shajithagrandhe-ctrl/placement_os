import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/storage/hive_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive Local Database
  await HiveService.init();

  runApp(
    // ProviderScope is required for all Riverpod state features
    const ProviderScope(
      child: PlacementOSApp(),
    ),
  );
}

class PlacementOSApp extends StatelessWidget {
  const PlacementOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PlacementOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Enforce dark theme
      routerConfig: appRouter,
    );
  }
}
