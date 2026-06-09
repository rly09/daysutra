import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/hive_repository.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await HiveRepository.init();

  runApp(
    const ProviderScope(
      child: DaySutraApp(),
    ),
  );
}

class DaySutraApp extends StatelessWidget {
  const DaySutraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaySūtra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
