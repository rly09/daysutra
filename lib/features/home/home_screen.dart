import 'package:flutter/material.dart';

import '../../presentation/widgets/floating_nav_bar.dart';
import 'widgets/bento_grid.dart';
import 'widgets/greeting_section.dart';
import '../notes/note_editor_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          IndexedStack(
            index: _currentIndex,
            children: [
              // Tab 0: Home
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
              // Tab 1: Settings
              const SettingsScreen(),
            ],
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
