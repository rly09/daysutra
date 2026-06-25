import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../presentation/widgets/glass_card.dart';
import '../../../data/repositories/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../folders/folders_screen.dart';

class FolderCard extends ConsumerWidget {
  const FolderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FoldersScreen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.folder, color: AppColors.lightSignalOrange, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'FOLDERS',
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.arrowRight, color: AppColors.slateGray, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: foldersAsync.when(
              data: (folders) {
                if (folders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.folderPlus,
                            color: Color(0xFF10B981),
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No folders yet',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.slateGray,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Tap to create one',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.dustTaupe,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: folders.length > 3 ? 3 : folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.folder, size: 16, color: AppColors.slateGray),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              folder.name,
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
