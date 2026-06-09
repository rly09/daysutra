import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/folder.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';

class FolderModal extends ConsumerStatefulWidget {
  const FolderModal({super.key});

  @override
  ConsumerState<FolderModal> createState() => _FolderModalState();
}

class _FolderModalState extends ConsumerState<FolderModal> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) return;

    final box = ref.read(foldersBoxProvider);
    final folder = Folder(
      name: _nameController.text.trim(),
    );
    box.add(folder);
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
            'New Folder',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Folder Name',
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.titleMedium,
            autofocus: true,
            onSubmitted: (_) => _save(),
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
