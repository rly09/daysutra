import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'life_goal.g.dart';

@HiveType(typeId: 3)
class LifeGoal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime createdAt;

  LifeGoal({
    String? id,
    required this.title,
    this.description = '',
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
}
