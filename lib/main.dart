import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'data/repositories/hive_repository.dart';
import 'core/utils/daily_refresh_manager.dart';
import 'core/utils/notification_service.dart';
import 'features/home/home_screen.dart';
import 'features/splash/providers/onboarding_provider.dart';
import 'features/splash/onboarding_screen.dart';
import 'data/repositories/providers.dart';
import 'core/services/home_widget_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveRepository.init();
  await DailyRefreshManager.checkAndRefreshTasks();
  
  // Initialize and Schedule Notifications safely
  final notificationService = NotificationService();
  try {
    await notificationService.init();
    await notificationService.scheduleDailyLifeGoalReminder();
    await notificationService.scheduleDailySarcasticReminder();
  } catch (e) {
    debugPrint("Failed to initialize or schedule notifications: $e");
  }

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
    ref.watch(isDarkProvider);

    // Synchronize isDarkProvider with actual media query system brightness changes
    final systemBrightness = MediaQuery.platformBrightnessOf(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentIsDark = themeMode == ThemeMode.dark ||
          (themeMode == ThemeMode.system && systemBrightness == Brightness.dark);
      if (ref.read(isDarkProvider) != currentIsDark) {
        ref.read(isDarkProvider.notifier).state = currentIsDark;
      }
    });

    // Watch and listen to providers to update home screen widgets in real time
    ref.listen(isDarkProvider, (previous, next) {
      final goals = ref.read(goalsProvider).valueOrNull ?? [];
      final goal = goals.isNotEmpty ? goals.first : null;
      final folders = ref.read(foldersProvider).valueOrNull ?? [];
      final tasks = ref.read(tasksProvider).valueOrNull ?? [];
      
      HomeWidgetManager.updateAllWidgets(
        goal: goal,
        folders: folders,
        tasks: tasks,
        isDark: next,
      );
    });

    ref.listen(goalsProvider, (previous, next) {
      final goals = next.valueOrNull ?? [];
      final goal = goals.isNotEmpty ? goals.first : null;
      HomeWidgetManager.updateLifeGoalWidget(goal, isDark: ref.read(isDarkProvider));
      HomeWidgetManager.updateInspirationWidget(goal, isDark: ref.read(isDarkProvider));
      NotificationService().scheduleDailyLifeGoalReminder();
    });

    ref.listen(foldersProvider, (previous, next) {
      final folders = next.valueOrNull ?? [];
      HomeWidgetManager.updateFoldersWidget(folders, isDark: ref.read(isDarkProvider));
    });

    ref.listen(tasksProvider, (previous, next) {
      final tasks = next.valueOrNull ?? [];
      HomeWidgetManager.updateTodoWidget(tasks, isDark: ref.read(isDarkProvider));
      NotificationService().scheduleDailySarcasticReminder();
    });

    ref.listen<bool>(allTasksCompletedProvider, (previous, next) {
      if (next && previous == false) {
        NotificationService().showCongratsNotification();
      }
    });

    return MaterialApp(
      title: 'DaySūtra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AppEntryGate(),
    );
  }
}

class AppEntryGate extends ConsumerWidget {
  const AppEntryGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingCompleted = ref.watch(onboardingCompletedProvider);
    if (!onboardingCompleted) {
      return const OnboardingScreen();
    }
    return const HomeScreen();
  }
}
