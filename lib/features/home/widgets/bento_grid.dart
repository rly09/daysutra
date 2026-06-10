import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'life_goal_card.dart';
import 'todo_card.dart';
import 'folder_card.dart';

class BentoGrid extends StatelessWidget {
  const BentoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
