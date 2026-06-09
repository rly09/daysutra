import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/repositories/providers.dart';
import '../../core/theme/app_colors.dart';
import 'note_editor_screen.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notes'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.filePlus),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NoteEditorScreen()));
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.fileText, size: 64, color: AppColors.dustTaupe),
                  const SizedBox(height: 16),
                  Text('No notes yet', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditorScreen(existingNote: note)));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.softBone),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              note.title.isNotEmpty ? note.title : 'Untitled',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (note.isFavorite)
                            const Icon(Icons.star, color: Colors.orange, size: 16),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.content,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
