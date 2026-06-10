import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/models/todo_task.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';
import '../../presentation/widgets/custom_feedback.dart';
import '../../core/theme/app_colors.dart';

class TodoModal extends ConsumerStatefulWidget {
  const TodoModal({super.key});

  @override
  ConsumerState<TodoModal> createState() => _TodoModalState();
}

class _TodoModalState extends ConsumerState<TodoModal> {
  late TextEditingController _titleController;
  int _priority = 1; // 0: Low, 1: Medium, 2: High

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;

    final box = ref.read(tasksBoxProvider);
    final task = TodoTask(
      title: _titleController.text.trim(),
      priority: _priority,
    );
    box.add(task);
    Navigator.of(context).pop();
    AppFeedback.showSuccessSnackBar(context, 'Task added to your list');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.dustTaupe.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Icon(LucideIcons.listTodo, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Add Task',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Task title...',
              hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              filled: true,
              fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            autofocus: true,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 24),
          Text('Priority', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              _PriorityChip(
                label: 'Low',
                isSelected: _priority == 0,
                onSelected: () => setState(() => _priority = 0),
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              _PriorityChip(
                label: 'Med',
                isSelected: _priority == 1,
                onSelected: () => setState(() => _priority = 1),
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              _PriorityChip(
                label: 'High',
                isSelected: _priority == 2,
                onSelected: () => setState(() => _priority = 2),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PillButton(
                label: 'Cancel',
                isPrimary: false,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 12),
              PillButton(
                label: 'Save',
                isPrimary: true,
                onPressed: _save,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final Color color;

  const _PriorityChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.softBone.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColors.slateGray,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
