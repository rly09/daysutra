import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../search/search_screen.dart';
import 'life_goal_card.dart';
import 'todo_card.dart';
import 'folder_card.dart';

class BentoGrid extends StatelessWidget {
  const BentoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HomeSearchBar()
            .animate()
            .fadeIn(duration: 500.ms, delay: 250.ms)
            .slideY(begin: 0.1, end: 0),
        const SizedBox(height: 16),
        const SizedBox(
          height: 200,
          width: double.infinity,
          child: LifeGoalCard(),
        ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: const SizedBox(
                height: 200,
                child: FolderCard(),
              ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.1, end: 0),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: const SizedBox(
                height: 200,
                child: TodoCard(),
              ).animate().fadeIn(duration: 500.ms, delay: 500.ms).slideY(begin: 0.1, end: 0),
            ),
          ],
        ),
      ],
    );
  }
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
          },
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.dustTaupe.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.search, size: 20, color: AppColors.slateGray),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search notes, tasks, goals...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.slateGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
