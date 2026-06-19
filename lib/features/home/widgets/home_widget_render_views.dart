import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/folder.dart';
import '../../../domain/models/todo_task.dart';

class HomeWidgetRenderViews {
  static Widget lifeGoal({
    required String title,
    required String description,
    bool isDark = false,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 360,
          height: 220,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.target, color: AppColors.signalOrange, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'LIFE GOAL',
                    style: TextStyle(
                      fontFamily: GoogleFonts.sofiaSans().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 312,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title.isNotEmpty ? title : 'No Life Goal Set',
                          style: TextStyle(
                            fontFamily: GoogleFonts.sofiaSans().fontFamily,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.canvasCream : AppColors.inkBlack,
                          ),
                        ),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontFamily: GoogleFonts.sofiaSans().fontFamily,
                              fontSize: 15,
                              height: 1.4,
                              color: isDark ? AppColors.dustTaupe : AppColors.slateGray,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget inspiration({
    ui.Image? uiImage,
    bool isDark = false,
  }) {
    final hasImage = uiImage != null;
    
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            color: isDark ? AppColors.inkBlack : AppColors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              if (hasImage)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: RawImage(
                      image: uiImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.signalOrange,
                          AppColors.lightSignalOrange,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.sparkles, color: Colors.white, size: 36),
                        const SizedBox(height: 16),
                        Text(
                          'Be the change you wish to see in the world.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: GoogleFonts.sofiaSans().fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (hasImage)
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
              if (hasImage)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.sparkles, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'INSPIRATION',
                            style: TextStyle(
                              fontFamily: GoogleFonts.sofiaSans().fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
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

  static Widget folders({
    required List<Folder> folders,
    bool isDark = false,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 360,
          height: 180,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.folder, color: AppColors.lightSignalOrange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'FOLDERS',
                    style: TextStyle(
                      fontFamily: GoogleFonts.sofiaSans().fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: folders.isEmpty
                    ? Center(
                        child: Text(
                          'No Folders',
                          style: TextStyle(
                            fontFamily: GoogleFonts.sofiaSans().fontFamily,
                            fontSize: 16,
                            color: AppColors.slateGray,
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: folders.take(2).map((folder) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.folder, size: 16, color: AppColors.slateGray),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    folder.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.sofiaSans().fontFamily,
                                      fontSize: 16,
                                      color: isDark ? AppColors.canvasCream : AppColors.inkBlack,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget todo({
    required List<TodoTask> tasks,
    bool isDark = false,
  }) {
    final completed = tasks.where((t) => t.isCompleted).length;
    final total = tasks.length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 360,
          height: 180,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.listTodo, color: AppColors.signalOrange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'TODO',
                    style: TextStyle(
                      fontFamily: GoogleFonts.sofiaSans().fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: total == 0
                    ? Center(
                        child: Text(
                          'No Tasks',
                          style: TextStyle(
                            fontFamily: GoogleFonts.sofiaSans().fontFamily,
                            fontSize: 16,
                            color: AppColors.slateGray,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 72,
                                height: 72,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 7,
                                  backgroundColor: isDark ? AppColors.charcoal : AppColors.softBone,
                                  color: AppColors.signalOrange,
                                ),
                              ),
                              Text(
                                '$completed/$total',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.sofiaSans().fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.canvasCream : AppColors.inkBlack,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 32),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Progress',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.sofiaSans().fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.canvasCream : AppColors.inkBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'tasks completed',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.sofiaSans().fontFamily,
                                  fontSize: 13,
                                  color: AppColors.slateGray,
                                ),
                              ),
                            ],
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
}
