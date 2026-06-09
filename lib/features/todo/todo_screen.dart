import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/repositories/providers.dart';
import '../../core/theme/app_colors.dart';
import 'todo_modal.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                builder: (_) => const TodoModal(),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.checkSquare, size: 64, color: AppColors.dustTaupe),
                  const SizedBox(height: 16),
                  Text('No tasks yet', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.softBone),
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (val) {
                      task.isCompleted = val ?? false;
                      task.save();
                    },
                    activeColor: AppColors.inkBlack,
                  ),
                  title: Text(
                    task.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? AppColors.slateGray : AppColors.inkBlack,
                        ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(LucideIcons.trash2, color: AppColors.slateGray, size: 20),
                    onPressed: () => task.delete(),
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
