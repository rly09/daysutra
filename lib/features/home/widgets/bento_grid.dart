import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/providers.dart';
import '../../search/search_screen.dart';
import 'life_goal_card.dart';
import 'inspiration_card.dart';
import 'todo_card.dart';
import 'folder_card.dart';

class BentoGrid extends ConsumerWidget {
  const BentoGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final notesAsync = ref.watch(notesProvider);
    final foldersAsync = ref.watch(foldersProvider);

    final taskCount = tasksAsync.valueOrNull?.length ?? 0;
    final completedCount = tasksAsync.valueOrNull?.where((t) => t.isCompleted).length ?? 0;
    final noteCount = notesAsync.valueOrNull?.length ?? 0;
    final folderCount = foldersAsync.valueOrNull?.length ?? 0;

    return Column(
      children: [
        const _HomeSearchBar()
            .animate()
            .fadeIn(duration: 500.ms, delay: 250.ms)
            .slideY(begin: 0.1, end: 0),
        const SizedBox(height: 16),

        // Quick stats strip
        _QuickStatsRow(
          taskCount: taskCount,
          completedCount: completedCount,
          noteCount: noteCount,
          folderCount: folderCount,
        ).animate().fadeIn(duration: 500.ms, delay: 280.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                flex: 3,
                child: LifeGoalCard(),
              ),
              const SizedBox(width: 16),
              const Expanded(
                flex: 2,
                child: InspirationCard(),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 320.ms).slideY(begin: 0.1, end: 0),
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

class _QuickStatsRow extends StatelessWidget {
  final int taskCount;
  final int completedCount;
  final int noteCount;
  final int folderCount;

  const _QuickStatsRow({
    required this.taskCount,
    required this.completedCount,
    required this.noteCount,
    required this.folderCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: LucideIcons.fileText,
            label: 'Notes',
            value: '$noteCount',
            iconColor: const Color(0xFF6366F1),
            bgColor: isDark
                ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                : const Color(0xFF6366F1).withValues(alpha: 0.08),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: LucideIcons.checkCircle,
            label: 'Done',
            value: '$completedCount/$taskCount',
            iconColor: AppColors.signalOrange,
            bgColor: isDark
                ? AppColors.signalOrange.withValues(alpha: 0.12)
                : AppColors.signalOrange.withValues(alpha: 0.08),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: LucideIcons.folder,
            label: 'Folders',
            value: '$folderCount',
            iconColor: const Color(0xFF10B981),
            bgColor: isDark
                ? const Color(0xFF10B981).withValues(alpha: 0.12)
                : const Color(0xFF10B981).withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color bgColor;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : iconColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    color: isDark ? Colors.white : AppColors.inkBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 10,
                    color: isDark ? Colors.white38 : AppColors.slateGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
