import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../presentation/widgets/glass_card.dart';
import '../../../data/repositories/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../goals/goal_modal.dart';

class LifeGoalCard extends ConsumerWidget {
  const LifeGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          builder: (_) => GoalModal(
            existingGoal: goalsAsync.valueOrNull?.isNotEmpty == true 
                ? goalsAsync.value!.first 
                : null,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.target, color: AppColors.signalOrange, size: 20),
              const SizedBox(width: 8),
              Text(
                'LIFE GOAL',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: goalsAsync.when(
              data: (goals) {
                if (goals.isEmpty) {
                  return Center(
                    child: Text(
                      '+ Add Life Goal',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.slateGray,
                          ),
                    ),
                  );
                }
                final goal = goals.first;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        goal.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }
}
