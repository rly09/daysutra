import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String? folderId;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  int? colorHex;

  @HiveField(7)
  bool isPinned;

  @HiveField(8)
  bool isFavorite;

  Note({
    String? id,
    this.title = '',
    this.content = '',
    this.folderId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.colorHex,
    this.isPinned = false,
    this.isFavorite = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
