import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../domain/models/note.dart';
import '../../domain/models/folder.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';
import '../../presentation/widgets/custom_feedback.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? existingNote;
  final String? initialFolderId;

  const NoteEditorScreen({super.key, this.existingNote, this.initialFolderId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Note _currentNote;
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.existingNote ?? Note(folderId: widget.initialFolderId ?? '');
    _titleController = TextEditingController(text: _currentNote.title);
    _contentController = TextEditingController(text: _currentNote.content);
    _selectedFolderId = _currentNote.folderId;
    
    _titleController.addListener(_updateCurrentNote);
    _contentController.addListener(_updateCurrentNote);
  }

  void _updateCurrentNote() {
    _currentNote.title = _titleController.text;
    _currentNote.content = _contentController.text;
    _currentNote.folderId = _selectedFolderId;
    _currentNote.updatedAt = DateTime.now();
  }

  void _saveAndExit() {
    _updateCurrentNote();
    
    if (_currentNote.title.isEmpty && _currentNote.content.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    if (_currentNote.isInBox) {
      _currentNote.save();
    } else {
      ref.read(notesBoxProvider).add(_currentNote);
    }
    
    AppFeedback.showSuccessSnackBar(context, 'Note saved');
    Navigator.of(context).pop();
  }

  void _showFolderPicker() {
    final foldersAsync = ref.read(foldersProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
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
            Text(
              'Move to Folder',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            foldersAsync.when(
              data: (folders) {
                return Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: folders.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          leading: const Icon(LucideIcons.xCircle, size: 20),
                          title: const Text('Unfiled'),
                          selected: _selectedFolderId == null || _selectedFolderId!.isEmpty,
                          onTap: () {
                            setState(() => _selectedFolderId = null);
                            Navigator.pop(context);
                          },
                        );
                      }
                      final folder = folders[index - 1];
                      return ListTile(
                        leading: const Icon(LucideIcons.folder, size: 20),
                        title: Text(folder.name),
                        selected: _selectedFolderId == folder.id,
                        onTap: () {
                          setState(() => _selectedFolderId = folder.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Error loading folders'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final folders = ref.watch(foldersProvider).value ?? [];
    final selectedFolder = folders.cast<Folder?>().firstWhere(
      (f) => f?.id == _selectedFolderId,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.star,
              color: _currentNote.isFavorite ? AppColors.signalOrange : AppColors.slateGray.withValues(alpha: 0.4),
            ),
            onPressed: () {
              setState(() {
                _currentNote.isFavorite = !_currentNote.isFavorite;
                if (_currentNote.isInBox) _currentNote.save();
              });
            },
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PillButton(
              label: 'Save',
              onPressed: _saveAndExit,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // FIXED ALIGNMENT
            children: [
              const SizedBox(height: 16),
              // Eyebrow: Folder and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _showFolderPicker,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          (selectedFolder?.name ?? 'UNFILED').toUpperCase(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.signalOrange,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.signalOrange),
                      ],
                    ),
                  ),
                  Text(
                    AppDateUtils.getFormattedDate().toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.slateGray.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
              
              const SizedBox(height: 32),
              
              // Title Field
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.dustTaupe.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: theme.textTheme.displayMedium,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
              
              const SizedBox(height: 16),
              
              // Content Field
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Start writing...',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.dustTaupe.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
