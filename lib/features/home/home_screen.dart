import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';

import 'package:home_widget/home_widget.dart';

import '../../presentation/widgets/floating_nav_bar.dart';
import 'widgets/bento_grid.dart';
import 'widgets/greeting_section.dart';
import '../notes/note_editor_screen.dart';
import '../notes/widgets/note_grid.dart';
import '../settings/settings_screen.dart';
import '../../data/repositories/providers.dart';
import '../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  late ConfettiController _confettiController;
  StreamSubscription<Uri?>? _widgetClickedSubscription;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _initHomeWidget();
  }

  void _initHomeWidget() {
    // Check if the app was launched by a home widget click
    HomeWidget.initiallyLaunchedFromHomeWidget().then((uri) {
      if (uri != null) {
        _handleHomeWidgetClick(uri);
      }
    });

    // Listen to widget clicks when the app is in background/foreground
    _widgetClickedSubscription = HomeWidget.widgetClicked.listen((uri) {
      if (uri != null) {
        _handleHomeWidgetClick(uri);
      }
    });
  }

  void _handleHomeWidgetClick(Uri uri) {
    debugPrint('Launched or clicked from HomeWidget: $uri');
    // Standard redirection is handled by the OS opening/resuming the app.
    // If specific navigation is required in the future, it can be routed here.
  }

  @override
  void dispose() {
    _widgetClickedSubscription?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

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
    // Listen to tasks completion for confetti
    ref.listen<bool>(allTasksCompletedProvider, (previous, next) {
      if (next && previous == false) {
        _confettiController.play();
      }
    });

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
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 120),
                      children: [
                        const GreetingSection(),
                        const SizedBox(height: 32),
                        const BentoGrid(),

                        unfiledNotesAsync.when(
                          data: (notes) {
                            if (notes.isEmpty) return const SizedBox.shrink();
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                NoteGrid(notes: notes),
                              ],
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (e, st) => const SizedBox.shrink(),
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

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.1, // Increased frequency
              numberOfParticles: 20,  // More particles per emission
              gravity: 0.1,
              colors: const [
                AppColors.signalOrange,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
                Colors.green,
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
