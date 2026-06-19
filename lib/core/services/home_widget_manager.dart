import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import '../../domain/models/folder.dart';
import '../../domain/models/life_goal.dart';
import '../../domain/models/todo_task.dart';
import '../../features/home/widgets/home_widget_render_views.dart';

class HomeWidgetManager {
  static Future<void> updateLifeGoalWidget(LifeGoal? goal, {bool isDark = false}) async {
    try {
      await HomeWidget.saveWidgetData('is_dark_theme', isDark);
      
      final title = goal?.title ?? '';
      final description = goal?.description ?? '';

      if (kDebugMode) {
        print('HomeWidgetManager: Rendering LifeGoal widget (Title: $title, IsDark: $isDark)');
      }

      await HomeWidget.renderFlutterWidget(
        HomeWidgetRenderViews.lifeGoal(title: title, description: description, isDark: isDark),
        key: 'life_goal_widget_image',
        logicalSize: const Size(360, 220),
      );

      await HomeWidget.updateWidget(
        androidName: 'LifeGoalWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error updating LifeGoal widget: $e');
    }
  }

  static Future<void> updateInspirationWidget(LifeGoal? goal, {bool isDark = false}) async {
    try {
      await HomeWidget.saveWidgetData('is_dark_theme', isDark);
      
      final imagePath = goal?.inspirationImagePath;
      ui.Image? decodedImage;

      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          decodedImage = await decodeImageFromList(bytes);
        }
      }

      if (kDebugMode) {
        print('HomeWidgetManager: Rendering Inspiration widget (HasImage: ${decodedImage != null}, IsDark: $isDark)');
      }

      await HomeWidget.renderFlutterWidget(
        HomeWidgetRenderViews.inspiration(uiImage: decodedImage, isDark: isDark),
        key: 'inspiration_widget_image',
        logicalSize: const Size(240, 240),
      );

      await HomeWidget.updateWidget(
        androidName: 'InspirationWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error updating Inspiration widget: $e');
    }
  }

  static Future<void> updateFoldersWidget(List<Folder> folders, {bool isDark = false}) async {
    try {
      await HomeWidget.saveWidgetData('is_dark_theme', isDark);

      if (kDebugMode) {
        print('HomeWidgetManager: Rendering Folders widget (${folders.length} folders, IsDark: $isDark)');
      }

      await HomeWidget.renderFlutterWidget(
        HomeWidgetRenderViews.folders(folders: folders, isDark: isDark),
        key: 'folders_widget_image',
        logicalSize: const Size(360, 180),
      );

      await HomeWidget.updateWidget(
        androidName: 'FoldersWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error updating Folders widget: $e');
    }
  }

  static Future<void> updateTodoWidget(List<TodoTask> tasks, {bool isDark = false}) async {
    try {
      await HomeWidget.saveWidgetData('is_dark_theme', isDark);

      if (kDebugMode) {
        print('HomeWidgetManager: Rendering Todo widget (${tasks.length} tasks, IsDark: $isDark)');
      }

      await HomeWidget.renderFlutterWidget(
        HomeWidgetRenderViews.todo(tasks: tasks, isDark: isDark),
        key: 'todo_widget_image',
        logicalSize: const Size(360, 180),
      );

      await HomeWidget.updateWidget(
        androidName: 'TodoWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error updating Todo widget: $e');
    }
  }

  static Future<void> updateAllWidgets({
    LifeGoal? goal,
    required List<Folder> folders,
    required List<TodoTask> tasks,
    bool isDark = false,
  }) async {
    await HomeWidget.saveWidgetData('is_dark_theme', isDark);
    await updateLifeGoalWidget(goal, isDark: isDark);
    await updateInspirationWidget(goal, isDark: isDark);
    await updateFoldersWidget(folders, isDark: isDark);
    await updateTodoWidget(tasks, isDark: isDark);
  }
}
