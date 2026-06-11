import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../presentation/widgets/glass_card.dart';
import '../../../data/repositories/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/life_goal.dart';

class InspirationCard extends ConsumerWidget {
  const InspirationCard({super.key});

  Future<void> _pickAndCropImage(BuildContext context, WidgetRef ref, LifeGoal? goal) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          cropStyle: CropStyle.circle,
          toolbarTitle: 'Crop Inspiration',
          toolbarColor: AppColors.signalOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          activeControlsWidgetColor: AppColors.signalOrange,
        ),
        IOSUiSettings(
          cropStyle: CropStyle.circle,
          title: 'Crop Inspiration',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );

    if (croppedFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(croppedFile.path);
    final savedImage = await File(croppedFile.path).copy('${appDir.path}/$fileName');

    if (goal != null) {
      goal.inspirationImagePath = savedImage.path;
      await goal.save();
    } else {
      final box = ref.read(goalsBoxProvider);
      final newGoal = LifeGoal(
        title: 'My Life Goal',
        inspirationImagePath: savedImage.path,
      );
      await box.add(newGoal);
    }
    
    ref.invalidate(goalsProvider);
  }

  Future<void> _deleteImage(BuildContext context, WidgetRef ref, LifeGoal? goal) async {
    if (goal == null || goal.inspirationImagePath == null) return;

    try {
      final file = File(goal.inspirationImagePath!);
      if (await file.exists()) {
        await file.delete();
      }
      goal.inspirationImagePath = null;
      await goal.save();
      ref.invalidate(goalsProvider);
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  void _showPreview(BuildContext context, String imagePath, WidgetRef ref, LifeGoal? goal) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PreviewActionButton(
                      icon: LucideIcons.camera,
                      label: 'Change',
                      onTap: () {
                        Navigator.pop(context);
                        _pickAndCropImage(context, ref, goal);
                      },
                    ),
                    const SizedBox(width: 12),
                    _PreviewActionButton(
                      icon: LucideIcons.trash2,
                      label: 'Delete',
                      isDestructive: true,
                      onTap: () {
                        Navigator.pop(context);
                        _deleteImage(context, ref, goal);
                      },
                    ),
                    const SizedBox(width: 12),
                    _PreviewActionButton(
                      icon: LucideIcons.x,
                      label: 'Close',
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);
    final theme = Theme.of(context);

    return goalsAsync.when(
      data: (goals) {
        final goal = goals.isNotEmpty ? goals.first : null;
        final imagePath = goal?.inspirationImagePath;

        return GlassCard(
          padding: EdgeInsets.zero,
          onTap: imagePath != null 
              ? () => _showPreview(context, imagePath, ref, goal)
              : () => _pickAndCropImage(context, ref, goal),
          child: Stack(
            children: [
              // Background Image
              if (imagePath != null)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              
              // Gradient Overlay (if image exists) to keep text readable
              if (imagePath != null)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                  ),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (imagePath == null)
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.sparkles, 
                            color: AppColors.signalOrange, 
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'INSPIRATION',
                              style: theme.textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: AppColors.slateGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    if (imagePath == null)
                      const Center(
                        child: Icon(
                          LucideIcons.plus,
                          color: AppColors.dustTaupe,
                          size: 32,
                        ),
                      ),
                    if (imagePath != null)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.maximize2,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const GlassCard(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => const GlassCard(
        child: Center(child: Text('Error')),
      ),
    );
  }
}

class _PreviewActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _PreviewActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDestructive 
              ? Colors.red.withValues(alpha: 0.2) 
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDestructive 
                ? Colors.red.withValues(alpha: 0.3) 
                : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              size: 16, 
              color: isDestructive ? Colors.redAccent : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDestructive ? Colors.redAccent : Colors.white, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
