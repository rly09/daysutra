import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/journal_entry.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';

class JournalModal extends ConsumerStatefulWidget {
  const JournalModal({super.key});

  @override
  ConsumerState<JournalModal> createState() => _JournalModalState();
}

class _JournalModalState extends ConsumerState<JournalModal> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _mood = 'Neutral';
  final List<String> moods = ['😊 Happy', '😐 Neutral', '😔 Sad', '🔥 Motivated', '😴 Tired'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;

    final box = ref.read(journalBoxProvider);
    final entry = JournalEntry(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      mood: _mood,
    );
    box.add(entry);
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Journal Entry',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title...',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.titleMedium,
              autofocus: true,
            ),
            const Divider(),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Write your thoughts...',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: moods.map((m) {
                  final isSelected = _mood == m;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(m),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _mood = m);
                      },
                    ),
                  );
                }).toList(),
              ),
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
      ),
    );
  }
}
