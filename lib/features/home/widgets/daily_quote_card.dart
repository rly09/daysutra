import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({super.key});

  static const List<Map<String, String>> _quotes = [
    {'quote': 'The secret of getting ahead is getting started.', 'author': 'Mark Twain'},
    {'quote': 'It does not matter how slowly you go as long as you do not stop.', 'author': 'Confucius'},
    {'quote': 'Everything you\'ve ever wanted is on the other side of fear.', 'author': 'George Addair'},
    {'quote': 'Success is not final, failure is not fatal: it is the courage to continue that counts.', 'author': 'Winston Churchill'},
    {'quote': 'Hardships often prepare ordinary people for an extraordinary destiny.', 'author': 'C.S. Lewis'},
    {'quote': 'The best time to plant a tree was 20 years ago. The second best time is now.', 'author': 'Chinese Proverb'},
    {'quote': 'An unexamined life is not worth living.', 'author': 'Socrates'},
    {'quote': 'Spread love everywhere you go. Let no one ever come to you without leaving happier.', 'author': 'Mother Teresa'},
    {'quote': 'When you reach the end of your rope, tie a knot in it and hang on.', 'author': 'Franklin D. Roosevelt'},
    {'quote': 'Always remember that you are absolutely unique. Just like everyone else.', 'author': 'Margaret Mead'},
    {'quote': 'Don\'t judge each day by the harvest you reap but by the seeds that you plant.', 'author': 'Robert Louis Stevenson'},
    {'quote': 'The future belongs to those who believe in the beauty of their dreams.', 'author': 'Eleanor Roosevelt'},
    {'quote': 'Tell me and I forget. Teach me and I remember. Involve me and I learn.', 'author': 'Benjamin Franklin'},
    {'quote': 'In the middle of every difficulty lies opportunity.', 'author': 'Albert Einstein'},
  ];

  Map<String, String> _getTodaysQuote() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return _quotes[dayOfYear % _quotes.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quote = _getTodaysQuote();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.signalOrange.withValues(alpha: 0.18),
                  AppColors.clayBrown.withValues(alpha: 0.10),
                ]
              : [
                  AppColors.signalOrange.withValues(alpha: 0.10),
                  AppColors.lightSignalOrange.withValues(alpha: 0.06),
                ],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.signalOrange.withValues(alpha: 0.2)
              : AppColors.signalOrange.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.quote,
                color: AppColors.signalOrange,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'QUOTE OF THE DAY',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: AppColors.signalOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '"${quote['quote']}"',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.55,
              color: isDark ? Colors.white.withValues(alpha: 0.88) : AppColors.inkBlack,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 24,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.signalOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                quote['author'] ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white54 : AppColors.slateGray,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 550.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
