import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class CelebrationDialog extends StatefulWidget {
  final String title;
  final String message;

  const CelebrationDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    // Trigger confetti explosion with a short delay for smoothness
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBorder = Border.all(
      color: (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: isDark ? 0.08 : 0.05),
      width: 1.5,
    );

    final linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.04 : 0.45),
        (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.04 : 0.45),
      ],
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 340),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              gradient: linearGradient,
              border: cardBorder,
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : AppColors.inkBlack).withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Glowing/Animated Trophy or Success Icon
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: AppColors.signalOrange.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.signalOrange.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.trophy,
                            color: AppColors.signalOrange,
                            size: 38,
                          ),
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(delay: 1.seconds, duration: 2.seconds, color: Colors.white.withValues(alpha: 0.45))
                          .animate()
                          .scale(duration: 600.ms, curve: Curves.easeOutBack)
                          .shake(delay: 600.ms, duration: 600.ms, hz: 3),

                      const SizedBox(height: 24),

                      // Title text
                      Text(
                        widget.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 23,
                          letterSpacing: -0.6,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),

                      const SizedBox(height: 12),

                      // Success Message
                      Text(
                        widget.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          height: 1.45,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),

                      const SizedBox(height: 28),

                      // Action button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.signalOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            elevation: 2,
                            shadowColor: AppColors.signalOrange.withValues(alpha: 0.3),
                            side: BorderSide.none,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Let's Go!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(LucideIcons.sparkles, size: 16),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 550.ms).scaleY(begin: 0.85, end: 1.0, curve: Curves.easeOutBack),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Confetti falling overlay
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.12,
            numberOfParticles: 40,
            gravity: 0.25,
            colors: const [
              AppColors.signalOrange,
              Colors.amber,
              Colors.lightBlue,
              Colors.pinkAccent,
              Colors.lightGreen,
              Colors.deepPurpleAccent,
            ],
          ),
        ),
      ],
    );
  }
}
