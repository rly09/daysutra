import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/providers.dart';
import '../../domain/models/todo_task.dart';

class TodoOverviewDialog extends ConsumerWidget {
  final VoidCallback onOpenTodoList;

  const TodoOverviewDialog({
    super.key,
    required this.onOpenTodoList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Dialog(
      backgroundColor: colors.surface,
      surfaceTintColor: colors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To-Do',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap a checkbox to mark progress.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onOpenTodoList,
                    icon: Icon(LucideIcons.pencilLine, color: colors.primary),
                    tooltip: 'Open to-do list',
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(LucideIcons.x, color: colors.onSurface),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: colors.outlineVariant.withValues(alpha: 0.45),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.checkSquare,
                              size: 44,
                              color: colors.onSurface.withValues(alpha: 0.35),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No tasks yet',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Use the pencil icon to open the full list.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurface.withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: tasks.length,
                      separatorBuilder: (_, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _TodoTaskRow(
                          task: tasks[index],
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodoTaskRow extends StatelessWidget {
  final TodoTask task;

  const _TodoTaskRow({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
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
          color: colors.onSurface.withValues(alpha: theme.brightness == Brightness.dark ? 0.05 : 0.03),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) async {
                  task.isCompleted = value ?? false;
                  await task.save();
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted
                        ? colors.onSurface.withValues(alpha: 0.6)
                        : colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
