import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'data/repositories/hive_repository.dart';
import 'core/utils/daily_refresh_manager.dart';
import 'core/utils/notification_service.dart';
import 'core/utils/background_task_service.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await HiveRepository.init();
  await DailyRefreshManager.checkAndRefreshTasks();
  
  // Initialize Notifications
  final notificationService = NotificationService();
  await notificationService.init();

  // Initialize Background Tasks
  BackgroundTaskService.init();
  BackgroundTaskService.scheduleTasks();

  runApp(
    const ProviderScope(
      child: DaySutraApp(),
    ),
  );
}

class DaySutraApp extends ConsumerWidget {
  const DaySutraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'DaySūtra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
