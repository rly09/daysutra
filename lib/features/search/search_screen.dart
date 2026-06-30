import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/repositories/providers.dart';
import '../../core/theme/app_colors.dart';
import '../notes/note_editor_screen.dart';
import '../todo/todo_modal.dart';
import '../goals/goal_modal.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);
    final goalsAsync = ref.watch(goalsProvider);
    final tasksAsync = ref.watch(tasksProvider);

    List<Widget> results = [];

    if (_query.isNotEmpty) {
      final queryLower = _query.toLowerCase();

      // Search Notes
      if (notesAsync.hasValue) {
        final matches = notesAsync.value!
            .where(
              (n) =>
                  n.title.toLowerCase().contains(queryLower) ||
                  n.content.toLowerCase().contains(queryLower),
            )
            .toList();
        for (var n in matches) {
          results.add(
            ListTile(
              leading: const Icon(LucideIcons.fileText),
              title: Text(n.title.isEmpty ? 'Untitled Note' : n.title),
              subtitle: Text(
                n.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoteEditorScreen(existingNote: n),
                ),
              ),
            ),
          );
        }
      }

      // Search Tasks
      if (tasksAsync.hasValue) {
        final matches = tasksAsync.value!
            .where((t) => t.title.toLowerCase().contains(queryLower))
            .toList();
        for (var t in matches) {
          results.add(
            ListTile(
              leading: const Icon(LucideIcons.checkSquare),
              title: Text(t.title),
              subtitle: Text(
                t.priority == 2
                    ? 'High priority'
                    : t.priority == 0
                    ? 'Low priority'
                    : 'Medium priority',
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  builder: (_) => TodoModal(existingTask: t),
                );
              },
            ),
          );
        }
      }

      // Search Goals
      if (goalsAsync.hasValue) {
        final matches = goalsAsync.value!
            .where(
              (g) =>
                  g.title.toLowerCase().contains(queryLower) ||
                  g.description.toLowerCase().contains(queryLower),
            )
            .toList();
        for (var g in matches) {
          results.add(
            ListTile(
              leading: const Icon(LucideIcons.target),
              title: Text(g.title),
              subtitle: const Text('Life Goal'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  builder: (_) => GoalModal(existingGoal: g),
                );
              },
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (val) {
            setState(() {
              _query = val;
            });
          },
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.x),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.search,
                    size: 64,
                    color: AppColors.dustTaupe,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search your second brain',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
            )
          : results.isEmpty
          ? const Center(child: Text('No results found.'))
          : ListView(children: results),
    );
  }
}
