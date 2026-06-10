import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/folder.dart';
import '../../domain/models/life_goal.dart';
import '../../domain/models/note.dart';
import '../../domain/models/todo_task.dart';

class HiveRepository {
  static const String foldersBoxName = 'foldersBox';
  static const String notesBoxName = 'notesBox';
  static const String tasksBoxName = 'tasksBox';
  static const String goalsBoxName = 'goalsBox';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(FolderAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TodoTaskAdapter());
    Hive.registerAdapter(LifeGoalAdapter());

    // Open Boxes
    await Hive.openBox<Folder>(foldersBoxName);
    await Hive.openBox<Note>(notesBoxName);
    await Hive.openBox<TodoTask>(tasksBoxName);
    await Hive.openBox<LifeGoal>(goalsBoxName);
  }

  // Generic methods
  Box<T> getBox<T>(String boxName) => Hive.box<T>(boxName);
}
