import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/providers.dart';
import '../../domain/models/todo_task.dart';
import '../../presentation/widgets/custom_feedback.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.colorScheme;

    ref.listen<bool>(allTasksCompletedProvider, (previous, next) {
      if (next && previous == false) {
        final navigator = Navigator.of(context);
        navigator.pop();
        AppFeedback.showCelebration(navigator.context);
      }
    });

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: isDark ? 0.1 : 0.05),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.05 : 0.4),
                    (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.05 : 0.4),
                  ],
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
                                    color: colors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap a checkbox to mark progress.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colors.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: onOpenTodoList,
                            icon: Icon(LucideIcons.pencilLine, color: AppColors.signalOrange, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: 0.05),
                            ),
                            tooltip: 'Open to-do list',
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(LucideIcons.x, color: colors.onSurface, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: 0.05),
                            ),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        height: 1,
                        color: colors.onSurface.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: tasksAsync.when(
                          data: (tasks) {
                            if (tasks.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 32),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        LucideIcons.checkSquare,
                                        size: 48,
                                        color: colors.onSurface.withValues(alpha: 0.2),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No tasks yet',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Use the pencil icon to open the full list.',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: colors.onSurface.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: tasks.length,
                              separatorBuilder: (_, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return _TodoTaskRow(
                                  task: tasks[index],
                                );
                              },
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: Text('Error: $e')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: isDark ? 0.08 : 0.04),
        border: Border.all(
          color: (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: 0.05),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 6,
                color: task.priority == 2
                    ? Colors.red.withValues(alpha: 0.8)
                    : task.priority == 0
                        ? Colors.green.withValues(alpha: 0.8)
                        : AppColors.signalOrange.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 4),
              Checkbox(
                value: task.isCompleted,
                activeColor: AppColors.signalOrange,
                side: BorderSide(color: colors.onSurface.withValues(alpha: 0.3)),
                onChanged: (value) async {
                  task.isCompleted = value ?? false;
                  await task.save();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    task.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted
                          ? colors.onSurface.withValues(alpha: 0.5)
                          : colors.onSurface,
                    ),
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
