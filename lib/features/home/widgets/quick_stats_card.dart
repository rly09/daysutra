import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../presentation/widgets/glass_card.dart';
import '../../../data/repositories/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../notes/notes_screen.dart';
import '../../diary/journal_screen.dart';

class QuickStatsCard extends ConsumerWidget {
  const QuickStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final journalAsync = ref.watch(journalProvider);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.barChart2, color: AppColors.clayBrown, size: 20),
              const SizedBox(width: 8),
              Text(
                'STATS',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Notes',
                  value: notesAsync.valueOrNull?.length.toString() ?? '0',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen()));
                  },
                ),
                _StatItem(
                  label: 'Journals',
                  value: journalAsync.valueOrNull?.length.toString() ?? '0',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _StatItem({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
