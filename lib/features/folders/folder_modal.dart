import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/models/folder.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';
import '../../presentation/widgets/custom_feedback.dart';
import '../../core/theme/app_colors.dart';

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
    AppFeedback.showSuccessSnackBar(context, 'Folder created');
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
              Icon(LucideIcons.folderPlus, color: theme.colorScheme.secondary),
              const SizedBox(width: 12),
              Text(
                'New Folder',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Folder Name',
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
                borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
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
