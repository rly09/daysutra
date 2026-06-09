import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../presentation/widgets/floating_nav_bar.dart';
import 'widgets/bento_grid.dart';
import 'widgets/greeting_section.dart';
import '../notes/note_editor_screen.dart';
import '../diary/journal_modal.dart';
import '../todo/todo_modal.dart';
import '../folders/folder_modal.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onAddTap() {
    // Open bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Create New', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(LucideIcons.fileText),
                title: const Text('New Note'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NoteEditorScreen()));
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.book),
                title: const Text('New Journal Entry'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    builder: (_) => const JournalModal(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.checkSquare),
                title: const Text('New Task'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    builder: (_) => const TodoModal(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.folder),
                title: const Text('New Folder'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    builder: (_) => const FolderModal(),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Scrollable Content
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 120),
              children: const [
                GreetingSection(),
                SizedBox(height: 48),
                BentoGrid(),
              ],
            ),
          ),
          // Floating Nav Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
              onAddTap: _onAddTap,
            ),
          ),
        ],
      ),
    );
  }
}
