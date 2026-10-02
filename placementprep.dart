import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const PlacementPrepApp(),
    ),
  );
}

class PlacementPrepApp extends StatelessWidget {
  const PlacementPrepApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Placement Prep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Premium Slate Dark Theme by default
      home: const MainLayout(),
    );
  }
}
