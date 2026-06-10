import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/models/life_goal.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';
import '../../presentation/widgets/custom_feedback.dart';
import '../../core/theme/app_colors.dart';

class GoalModal extends ConsumerStatefulWidget {
  final LifeGoal? existingGoal;

  const GoalModal({super.key, this.existingGoal});

  @override
  ConsumerState<GoalModal> createState() => _GoalModalState();
}

class _GoalModalState extends ConsumerState<GoalModal> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingGoal?.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;

    final box = ref.read(goalsBoxProvider);
    final bool isUpdating = widget.existingGoal != null;

    if (isUpdating) {
      widget.existingGoal!.title = _titleController.text.trim();
      // Keep existing description or clear it if the user wants it removed entirely from data
      // For now, just keeping it unchanged or empty
      widget.existingGoal!.save();
    } else {
      final goal = LifeGoal(
        title: _titleController.text.trim(),
        description: '', // Removing description from UI, so defaulting to empty
      );
      box.add(goal);
    }
    
    Navigator.of(context).pop();
    
    AppFeedback.showSuccessSnackBar(
      context, 
      isUpdating ? 'Goal updated successfully' : 'Life goal added! Stay focused.',
    );
  }

  void _delete() {
    if (widget.existingGoal != null) {
      widget.existingGoal!.delete();
      Navigator.of(context).pop();
      AppFeedback.showInfoSnackBar(context, 'Goal deleted');
    }
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
              const Icon(LucideIcons.target, color: AppColors.signalOrange),
              const SizedBox(width: 12),
              Text(
                widget.existingGoal == null ? 'Add Life Goal' : 'Edit Life Goal',
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
              hintText: 'What is your main goal?',
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
                borderSide: const BorderSide(color: AppColors.signalOrange, width: 2),
              ),
              filled: true,
              fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            autofocus: true,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              if (widget.existingGoal != null)
                IconButton(
                  onPressed: _delete,
                  icon: const Icon(LucideIcons.trash2, color: AppColors.signalOrange),
                ),
              const Spacer(),
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
