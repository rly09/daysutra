import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/life_goal.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';

class GoalModal extends ConsumerStatefulWidget {
  final LifeGoal? existingGoal;

  const GoalModal({super.key, this.existingGoal});

  @override
  ConsumerState<GoalModal> createState() => _GoalModalState();
}

class _GoalModalState extends ConsumerState<GoalModal> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingGoal?.title ?? '');
    _descController = TextEditingController(text: widget.existingGoal?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;

    final box = ref.read(goalsBoxProvider);
    if (widget.existingGoal != null) {
      widget.existingGoal!.title = _titleController.text.trim();
      widget.existingGoal!.description = _descController.text.trim();
      widget.existingGoal!.save();
    } else {
      final goal = LifeGoal(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      );
      box.add(goal);
    }
    Navigator.of(context).pop();
  }

  void _delete() {
    if (widget.existingGoal != null) {
      widget.existingGoal!.delete();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.existingGoal == null ? 'Add Life Goal' : 'Edit Life Goal',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'What is your main goal?',
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.titleMedium,
            autofocus: true,
          ),
          const Divider(),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              hintText: 'Describe it...',
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.existingGoal != null)
                TextButton(
                  onPressed: _delete,
                  child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              const Spacer(),
              PillButton(
                label: 'Cancel',
                isPrimary: false,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              PillButton(
                label: 'Save',
                isPrimary: true,
                onPressed: _save,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
