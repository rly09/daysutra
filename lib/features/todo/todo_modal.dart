import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/todo_task.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';

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
            'Add Task',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Task title...',
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            autofocus: true,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Priority: ', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Low'),
                selected: _priority == 0,
                onSelected: (val) => setState(() => _priority = 0),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Med'),
                selected: _priority == 1,
                onSelected: (val) => setState(() => _priority = 1),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('High'),
                selected: _priority == 2,
                onSelected: (val) => setState(() => _priority = 2),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
