import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../presentation/widgets/glass_card.dart';
import '../../../data/repositories/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../todo/todo_overview_dialog.dart';
import '../../todo/todo_screen.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      onTap: () {
        final tasks = tasksAsync.value ?? [];
        
        if (tasks.isEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TodoScreen()),
          );
          return;
        }

        showDialog(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.2),
          builder: (dialogContext) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: TodoOverviewDialog(
                onOpenTodoList: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TodoScreen()),
                  );
                },
              ),
            );
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.listTodo, color: AppColors.signalOrange, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'TODO',
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.arrowRight, color: AppColors.slateGray, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      '+ Add Task',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.slateGray,
                          ),
                    ),
                  );
                }
                
                int completed = tasks.where((t) => t.isCompleted).length;
                int total = tasks.length;
                double progress = total == 0 ? 0 : completed / total;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: AppColors.softBone,
                            color: AppColors.signalOrange,
                          ),
                        ),
                        Text(
                          '$completed/$total',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'completed',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }
}
