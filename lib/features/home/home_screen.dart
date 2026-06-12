import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../presentation/widgets/floating_nav_bar.dart';
import 'widgets/bento_grid.dart';
import 'widgets/greeting_section.dart';
import '../notes/note_editor_screen.dart';
import '../notes/widgets/note_grid.dart';
import '../settings/settings_screen.dart';
import '../../data/repositories/providers.dart';
import '../../core/theme/app_colors.dart';

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
                child: Consumer(
                  builder: (context, ref, child) {
                    final unfiledNotesAsync = ref.watch(unfiledNotesProvider);

                    return ListView(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 120),
                      children: [
                        const GreetingSection(),
                        const SizedBox(height: 48),
                        const BentoGrid(),
                        
                        unfiledNotesAsync.when(
                          data: (notes) {
                            if (notes.isEmpty) return const SizedBox.shrink();
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 48),
                                Text(
                                  'QUICK NOTES',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.signalOrange,
                                    letterSpacing: 2,
                                  ),
                                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
                                const SizedBox(height: 24),
                                NoteGrid(notes: notes),
                              ],
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    );
                  },
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
