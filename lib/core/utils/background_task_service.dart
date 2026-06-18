import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/todo_task.dart';
import '../../domain/models/life_goal.dart';
import '../../domain/models/folder.dart';
import '../../domain/models/note.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // Initialize Hive for background process
    await Hive.initFlutter();
    Hive.registerAdapter(TodoTaskAdapter());
    Hive.registerAdapter(LifeGoalAdapter());
    Hive.registerAdapter(FolderAdapter());
    Hive.registerAdapter(NoteAdapter());

    final notificationService = NotificationService();
    await notificationService.init();

    // Check for 9 PM task (Sarcastic reminder)
    if (taskName == "sarcastic_reminder") {
      await notificationService.checkAndNotifySarcastic();
    } 
    // Check for 8 AM task (Life Goal reminder)
    else if (taskName == "life_goal_reminder") {
      await notificationService.notifyLifeGoal();
    }

    return Future.value(true);
  });
}

class BackgroundTaskService {
  static void init() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static void scheduleTasks() {
    final now = DateTime.now();
    
    // Schedule 8 AM reminder
    DateTime eightAM = DateTime(now.year, now.month, now.day, 8, 0);
    if (now.isAfter(eightAM)) {
      eightAM = eightAM.add(const Duration(days: 1));
    }
    final delayEightAM = eightAM.difference(now);

    Workmanager().registerPeriodicTask(
      "life_goal_reminder_task",
      "life_goal_reminder",
      frequency: const Duration(days: 1),
      initialDelay: delayEightAM,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    // Schedule 9 PM reminder
    DateTime ninePM = DateTime(now.year, now.month, now.day, 21, 0);
    if (now.isAfter(ninePM)) {
      ninePM = ninePM.add(const Duration(days: 1));
    }
    final delayNinePM = ninePM.difference(now);

    Workmanager().registerPeriodicTask(
      "sarcastic_reminder_task",
      "sarcastic_reminder",
      frequency: const Duration(days: 1),
      initialDelay: delayNinePM,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }
}
