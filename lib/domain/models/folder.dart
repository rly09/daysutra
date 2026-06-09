import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'folder.g.dart';

@HiveType(typeId: 0)
class Folder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime createdAt;

  Folder({
    String? id,
    required this.name,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
}
