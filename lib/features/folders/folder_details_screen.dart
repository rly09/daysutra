import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/models/folder.dart';
import '../../data/repositories/providers.dart';
import '../../core/theme/app_colors.dart';
import '../notes/note_editor_screen.dart';
import '../notes/widgets/note_grid.dart';

class FolderDetailsScreen extends ConsumerWidget {
  final Folder folder;

  const FolderDetailsScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.trash2, color: AppColors.signalOrange),
            onPressed: () {
              folder.delete();
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          final folderNotes = notes.where((n) => n.folderId == folder.id).toList();

          if (folderNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.fileText, size: 64, color: AppColors.dustTaupe),
                  const SizedBox(height: 16),
                  Text('No notes in this folder', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              NoteGrid(notes: folderNotes),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditorScreen(initialFolderId: folder.id)));
        },
        backgroundColor: AppColors.inkBlack,
        foregroundColor: AppColors.canvasCream,
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
