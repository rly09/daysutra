import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/repositories/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/simple_card.dart';
import 'folder_modal.dart';
import 'folder_details_screen.dart';

class FoldersScreen extends ConsumerWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.folderPlus),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                builder: (_) => const FolderModal(),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: foldersAsync.when(
        data: (folders) {
          if (folders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.folder, size: 64, color: AppColors.dustTaupe),
                  const SizedBox(height: 16),
                  Text('No folders yet', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: folders.length,
            itemBuilder: (context, index) {
              final folder = folders[index];
              return SimpleCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FolderDetailsScreen(folder: folder)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.folder, size: 32, color: AppColors.lightSignalOrange),
                    const SizedBox(height: 16),
                    Text(
                      folder.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
