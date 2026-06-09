import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 4)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String mood; // "Happy", "Neutral", "Sad", "Motivated", "Tired"

  @HiveField(4)
  DateTime createdAt;

  JournalEntry({
    String? id,
    required this.title,
    required this.content,
    required this.mood,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
}
