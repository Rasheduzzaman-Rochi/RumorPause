import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/rumor_pause/screens/rumor_pause_flow_screen.dart';

class RumorPauseApp extends StatelessWidget {
  const RumorPauseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RumorPause',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RumorPauseFlowScreen(),
    );
  }
}
