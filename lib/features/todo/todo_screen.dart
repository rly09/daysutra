import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/models/todo_task.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/custom_feedback.dart';
import '../../presentation/widgets/simple_card.dart';
import '../../core/theme/app_colors.dart';
import 'todo_modal.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  Future<void> _deleteTask(BuildContext context, TodoTask task) async {
    await task.delete();
    if (!context.mounted) return;
    AppFeedback.showInfoSnackBar(context, 'Task deleted');
  }

  Future<void> _confirmDeleteTask(BuildContext context, TodoTask task) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        icon: Icon(LucideIcons.trash2, color: colors.error),
        title: const Text('Delete task?'),
        content: const Text('This task will be removed from your list.'),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      unawaited(_deleteTask(context, task));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    ref.listen(tasksProvider, (previous, next) {
      final prevTasks = previous?.valueOrNull;
      final nextTasks = next.valueOrNull;

      if (prevTasks != null && nextTasks != null && nextTasks.isNotEmpty) {
        final wasAllCompleted = prevTasks.isNotEmpty && prevTasks.every((t) => t.isCompleted);
        final isAllCompleted = nextTasks.every((t) => t.isCompleted);

        if (isAllCompleted && !wasAllCompleted) {
          AppFeedback.showSuccessSnackBar(context, "All tasks completed! Amazing job! 🎉");
        }
      }
    });

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
                backgroundColor: Colors.transparent,
                elevation: 0,
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
                  Icon(
                    LucideIcons.checkSquare,
                    size: 64,
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text('No tasks yet', style: theme.textTheme.titleLarge),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: ValueKey(task.id),
                direction: DismissDirection.startToEnd,
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: colors.error.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.18 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colors.error.withValues(alpha: 0.22),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(LucideIcons.trash2, color: colors.error, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Delete',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                onDismissed: (_) => unawaited(_deleteTask(context, task)),
                child: SimpleCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border(
                        left: BorderSide(
                          color: task.priority == 2
                              ? Colors.red
                              : task.priority == 0
                              ? Colors.green
                              : AppColors.lightSignalOrange,
                          width: 5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: task.isCompleted,
                            checkColor: colors.onPrimary,
                            fillColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return colors.primary;
                              }
                              return colors.surface;
                            }),
                            side: BorderSide(
                              color: colors.onSurface.withValues(alpha: 0.35),
                            ),
                            onChanged: (val) {
                              task.isCompleted = val ?? false;
                              task.save();
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: task.isCompleted
                                        ? colors.onSurface.withValues(
                                            alpha: 0.65,
                                          )
                                        : colors.onSurface,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              LucideIcons.trash2,
                              color: colors.onSurface.withValues(alpha: 0.65),
                              size: 20,
                            ),
                            onPressed: () => _confirmDeleteTask(context, task),
                          ),
                        ],
                      ),
                    ),
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
