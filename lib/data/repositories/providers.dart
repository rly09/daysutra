import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/folder.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/life_goal.dart';
import '../../domain/models/note.dart';
import '../../domain/models/todo_task.dart';
import 'hive_repository.dart';

final foldersBoxProvider = Provider<Box<Folder>>((ref) {
  return Hive.box<Folder>(HiveRepository.foldersBoxName);
});

final notesBoxProvider = Provider<Box<Note>>((ref) {
  return Hive.box<Note>(HiveRepository.notesBoxName);
});

final tasksBoxProvider = Provider<Box<TodoTask>>((ref) {
  return Hive.box<TodoTask>(HiveRepository.tasksBoxName);
});

final goalsBoxProvider = Provider<Box<LifeGoal>>((ref) {
  return Hive.box<LifeGoal>(HiveRepository.goalsBoxName);
});

final journalBoxProvider = Provider<Box<JournalEntry>>((ref) {
  return Hive.box<JournalEntry>(HiveRepository.journalBoxName);
});

// ValueListenable providers for reactive UI
final tasksListenableProvider = Provider<ValueNotifier<Box<TodoTask>>>((ref) {
  final box = ref.watch(tasksBoxProvider);
  return ValueNotifier(box)..addListener(() {});
});
// Using Riverpod to listen to Hive changes
final tasksProvider = StreamProvider<List<TodoTask>>((ref) {
  final box = ref.watch(tasksBoxProvider);
  return box.watch().map((event) => box.values.toList()).startWith(box.values.toList());
});

final goalsProvider = StreamProvider<List<LifeGoal>>((ref) {
  final box = ref.watch(goalsBoxProvider);
  return box.watch().map((event) => box.values.toList()).startWith(box.values.toList());
});

final notesProvider = StreamProvider<List<Note>>((ref) {
  final box = ref.watch(notesBoxProvider);
  return box.watch().map((event) => box.values.toList()).startWith(box.values.toList());
});

final foldersProvider = StreamProvider<List<Folder>>((ref) {
  final box = ref.watch(foldersBoxProvider);
  return box.watch().map((event) => box.values.toList()).startWith(box.values.toList());
});

final journalProvider = StreamProvider<List<JournalEntry>>((ref) {
  final box = ref.watch(journalBoxProvider);
  return box.watch().map((event) => box.values.toList()).startWith(box.values.toList());
});

extension StreamExt<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
