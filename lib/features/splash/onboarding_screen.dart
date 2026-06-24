import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import 'providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Row: Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < 2)
                    TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        '• SKIP',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.slateGray,
                          letterSpacing: 2.0,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 48), // Spacer to prevent jump
                ],
              ),
            ),

            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildFirstSlide(context, isDark),
                  _buildSecondSlide(context, isDark),
                  _buildThirdSlide(context, isDark),
                ],
              ),
            ),

            // Bottom Navigation and Indicators
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 40.0, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(3, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8.0),
                        height: 8.0,
                        width: isActive ? 24.0 : 8.0,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.lightSignalOrange
                              : (isDark
                                  ? AppColors.slateGray.withValues(alpha: 0.4)
                                  : AppColors.dustTaupe),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),

                  // Action Button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == 2 ? 'Begin journey' : 'Continue',
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentPage == 2 ? LucideIcons.rocket : LucideIcons.arrowRight,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstSlide(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.3 : 0.06);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Orbital Constellation Illustration
              SizedBox(
                height: 260,
                width: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ghost Watermark text in background
                    Positioned(
                      left: -20,
                      top: 40,
                      child: Text(
                        'SŪTRA',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 84,
                          color: isDark
                              ? const Color(0xFF1E1E1C)
                              : AppColors.canvasCream.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w700,
                          letterSpacing: -4.0,
                        ),
                      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.9, 0.9)),
                    ),

                    // Custom Painted Orbital Arc
                    CustomPaint(
                      size: const Size(200, 200),
                      painter: _OrbitPainter(
                        color: AppColors.lightSignalOrange.withValues(alpha: 0.8),
                      ),
                    ),

                    // Logo Circular Portrait
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1C) : AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Elegant fallback if logo is not loaded
                              return Icon(
                                LucideIcons.sparkles,
                                size: 52,
                                color: AppColors.signalOrange,
                              );
                            },
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),

                    // Satellite micro-CTA
                    Positioned(
                      bottom: 42,
                      right: 42,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.white : AppColors.inkBlack,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          LucideIcons.arrowUpRight,
                          color: isDark ? AppColors.inkBlack : AppColors.canvasCream,
                          size: 16,
                        ),
                      ).animate(delay: 400.ms).fadeIn().scale(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Eyebrow
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.signalOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'WELCOME',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.signalOrange,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 16),

              // Title
              Text(
                'Capture what matters.',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium,
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.15, end: 0),
              const SizedBox(height: 16),

              // Description
              Text(
                'DaySūtra is your second brain. A space designed to shape your thoughts, track your focus, and align your life goals.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.dustTaupe : AppColors.slateGray,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.15, end: 0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSecondSlide(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final cardBg = isDark ? const Color(0xFF1E1E1C) : AppColors.white;
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.3 : 0.08);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Bento Stack Illustration
              SizedBox(
                height: 260,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back Card: Folder Representation
                    Transform.translate(
                      offset: const Offset(-45, -20),
                      child: Transform.rotate(
                        angle: -0.08,
                        child: Container(
                          width: 140,
                          height: 140,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF262624) : AppColors.liftedCream,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? Colors.transparent : AppColors.dustTaupe.withValues(alpha: 0.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                blurRadius: 20,
                                offset: const Offset(-4, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.signalOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.folder,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Ideas',
                                style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '12 notes',
                                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),

                    // Middle Card: Todo List Item
                    Transform.translate(
                      offset: const Offset(45, 10),
                      child: Transform.rotate(
                        angle: 0.06,
                        child: Container(
                          width: 150,
                          height: 120,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                blurRadius: 24,
                                offset: const Offset(4, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.checkCircle2,
                                    color: AppColors.lightSignalOrange,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Daily meditation',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 12, thickness: 0.5),
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.circle,
                                    color: isDark ? AppColors.dustTaupe : AppColors.slateGray,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Write 500 words',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 150.ms).slideX(begin: 0.2, end: 0),

                    // Foreground Card: Note/Sutra Item
                    Transform.translate(
                      offset: const Offset(-5, 45),
                      child: Container(
                        width: 160,
                        height: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2A) : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.lightSignalOrange.withValues(alpha: 0.4), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Morning Reflection',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 13,
                                color: AppColors.lightSignalOrange,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Quiet the mind, and the soul will speak...',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 11,
                                height: 1.3,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).scale(begin: const Offset(0.9, 0.9)),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Eyebrow
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.signalOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ORGANISE',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.signalOrange,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 16),

              // Title
              Text(
                'Every thought in its place.',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium,
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.15, end: 0),
              const SizedBox(height: 16),

              // Description
              Text(
                'Jot down daily notes, structure tasks with checkboxes, and categorize your sparks of inspiration into folders seamlessly.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.dustTaupe : AppColors.slateGray,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.15, end: 0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThirdSlide(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final cardBg = isDark ? const Color(0xFF1E1E1C) : AppColors.white;
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.3 : 0.08);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Target Goal Illustration
              SizedBox(
                height: 260,
                width: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Dotted Orbits
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.lightSignalOrange.withValues(alpha: 0.3),
                          width: 1.5,
                          style: BorderStyle.solid, // fallback for dashed
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),

                    // Inner circle
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.lightSignalOrange.withValues(alpha: 0.6),
                          width: 1,
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.85, 0.85)),

                    // Stadium Card (Life Goal Card)
                    Container(
                      width: 180,
                      height: 100,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(40), // 40px as per DESIGN.md
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.inkBlack,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.target,
                                  color: AppColors.canvasCream,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'LIFE GOAL',
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontSize: 10,
                                        color: AppColors.signalOrange,
                                      ),
                                    ),
                                    Text(
                                      'Learn Spanish',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: 0.7,
                              minHeight: 6,
                              backgroundColor: isDark ? Colors.grey[800] : AppColors.canvasCream,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lightSignalOrange),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 700.ms, delay: 200.ms).scale(begin: const Offset(0.9, 0.9)),

                    // Floating check mark satellite
                    Positioned(
                      top: 45,
                      right: 35,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          LucideIcons.check,
                          color: AppColors.signalOrange,
                          size: 16,
                        ),
                      ).animate(delay: 500.ms).fadeIn().scale(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Eyebrow
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.signalOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PROGRESS',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.signalOrange,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 16),

              // Title
              Text(
                'Let\'s shape your day.',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium,
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.15, end: 0),
              const SizedBox(height: 16),

              // Description
              Text(
                'Set ambitious Life Goals, map your focus steps, and visualize your progress on a beautiful bento dashboard. Let every day align with your aspirations.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.dustTaupe : AppColors.slateGray,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.15, end: 0),
            ],
          ),
        );
      },
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final Color color;
  _OrbitPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw partial arc mimicking hand-drawn orbit
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.4, // start angle
      4.2,  // sweep angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
