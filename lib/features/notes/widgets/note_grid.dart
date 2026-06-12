import 'package:flutter/material.dart';
import '../../../domain/models/note.dart';
import 'note_card.dart';

class NoteGrid extends StatelessWidget {
  final List<Note> notes;
  const NoteGrid({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < notes.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: (i % 4 == 0) ? 3 : 2,
                  child: SizedBox(
                    height: 200,
                    child: NoteCard(note: notes[i]),
                  ),
                ),
                const SizedBox(width: 16),
                if (i + 1 < notes.length)
                  Expanded(
                    flex: (i % 4 == 0) ? 2 : 3,
                    child: SizedBox(
                      height: 200,
                      child: NoteCard(note: notes[i + 1]),
                    ),
                  )
                else
                  Expanded(
                    flex: (i % 4 == 0) ? 2 : 3,
                    child: const SizedBox(),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
