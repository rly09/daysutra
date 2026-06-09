import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../search/search_screen.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DaySūtra',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.signalOrange,
                    letterSpacing: 2,
                  ),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
            Row(
              children: [
                Text(
                  AppDateUtils.getFormattedDate(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2, end: 0),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(LucideIcons.search, color: AppColors.slateGray),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                  },
                ).animate().fadeIn(duration: 400.ms),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          AppDateUtils.getRandomGreeting(),
          style: Theme.of(context).textTheme.displayMedium,
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
