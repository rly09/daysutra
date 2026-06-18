import 'package:hive/hive.dart';
import '../../data/repositories/hive_repository.dart';
import '../../domain/models/todo_task.dart';

class DailyRefreshManager {
  static const String _lastResetKey = 'lastResetDate';

  static Future<void> checkAndRefreshTasks() async {
    final settingsBox = Hive.box(HiveRepository.settingsBoxName);
    final tasksBox = Hive.box<TodoTask>(HiveRepository.tasksBoxName);

    final lastResetDate = settingsBox.get(_lastResetKey) as String?;
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastResetDate != today) {
      // It's a new day, refresh tasks
      for (var i = 0; i < tasksBox.length; i++) {
        final task = tasksBox.getAt(i);
        if (task != null && task.isCompleted) {
          task.isCompleted = false;
          await task.save();
        }
      }

      // Update last reset date
      await settingsBox.put(_lastResetKey, today);
    }
  }
}
