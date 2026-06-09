import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'todo_task.g.dart';

@HiveType(typeId: 2)
class TodoTask extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  int priority; // 0: Low, 1: Medium, 2: High

  @HiveField(4)
  DateTime createdAt;

  TodoTask({
    String? id,
    required this.title,
    this.isCompleted = false,
    this.priority = 1,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
}
