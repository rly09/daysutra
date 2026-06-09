import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/note.dart';
import '../../data/repositories/providers.dart';
import '../../presentation/widgets/pill_button.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? existingNote;

  const NoteEditorScreen({super.key, this.existingNote});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Note _currentNote;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.existingNote ?? Note();
    _titleController = TextEditingController(text: _currentNote.title);
    _contentController = TextEditingController(text: _currentNote.content);
    
    // Auto-save listeners
    _titleController.addListener(_autoSave);
    _contentController.addListener(_autoSave);
  }

  void _autoSave() {
    _currentNote.title = _titleController.text;
    _currentNote.content = _contentController.text;
    _currentNote.updatedAt = DateTime.now();
    
    if (_currentNote.isInBox) {
      _currentNote.save();
    } else if (_currentNote.title.isNotEmpty || _currentNote.content.isNotEmpty) {
      ref.read(notesBoxProvider).add(_currentNote);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              _currentNote.isFavorite ? Icons.star : Icons.star_border,
              color: _currentNote.isFavorite ? Colors.orange : null,
            ),
            onPressed: () {
              setState(() {
                _currentNote.isFavorite = !_currentNote.isFavorite;
                _autoSave();
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.displayMedium,
              maxLines: null,
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
