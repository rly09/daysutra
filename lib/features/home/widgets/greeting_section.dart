import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getTimeEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 17) return '🌤️';
    return '🌙';
  }

  String _getDayOfWeek(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: App name + Date chip
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App icon
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/logo_foreground.png',
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : AppColors.signalOrange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.signalOrange.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                AppDateUtils.getFormattedDate(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppColors.signalOrange,
                  fontSize: 12,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2, end: 0),
          ],
        ),
        const SizedBox(height: 28),

        // Day of week label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.inkBlack.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getDayOfWeek(now.weekday).toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: isDark ? Colors.white54 : AppColors.slateGray,
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.2, end: 0),

        const SizedBox(height: 12),

        // Time greeting + emoji
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _getTimeGreeting(),
                style: theme.textTheme.displayMedium,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _getTimeEmoji(),
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 150.ms).slideY(begin: 0.2, end: 0),

        const SizedBox(height: 8),

        // Motivational sub-text
        Text(
          AppDateUtils.getRandomGreeting(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white54 : AppColors.slateGray,
            fontSize: 15,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 250.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
