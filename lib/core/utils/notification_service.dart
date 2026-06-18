import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/todo_task.dart';
import '../../domain/models/life_goal.dart';
import '../../data/repositories/hive_repository.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  final List<String> _sarcasticMessages = [
    "Oh, look who's still got tasks. 9 PM and you're already giving up?",
    "Your todo list is crying. Do you enjoy being unproductive?",
    "Another day, another set of incomplete goals. Consistency is key, I guess?",
    "I'd remind you to finish your tasks, but we both know you're 'too busy' scrolling.",
    "Is 'procrastination' a life goal of yours? Because you're winning.",
    "Tick tock. 9 PM. Your tasks are still there. Just like your unfulfilled potential.",
  ];

  Future<void> init() async {
    tz_data.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daysutra_reminders',
      'DaySutra Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
    );
  }

  Future<void> checkAndNotifySarcastic() async {
    if (!Hive.isBoxOpen(HiveRepository.tasksBoxName)) {
      await Hive.openBox<TodoTask>(HiveRepository.tasksBoxName);
    }
    
    final tasksBox = Hive.box<TodoTask>(HiveRepository.tasksBoxName);
    final incompleteCount = tasksBox.values.where((task) => !task.isCompleted).length;

    if (incompleteCount > 0) {
      final random = Random();
      final message = _sarcasticMessages[random.nextInt(_sarcasticMessages.length)];
      await showNotification(
        id: 1,
        title: "Still Slacking?",
        body: "$message ($incompleteCount tasks left)",
      );
    }
  }

  Future<void> notifyLifeGoal() async {
    if (!Hive.isBoxOpen(HiveRepository.goalsBoxName)) {
      await Hive.openBox<LifeGoal>(HiveRepository.goalsBoxName);
    }

    final goalsBox = Hive.box<LifeGoal>(HiveRepository.goalsBoxName);
    if (goalsBox.isNotEmpty) {
      final goal = goalsBox.values.first;
      await showNotification(
        id: 2,
        title: "Morning Motivation",
        body: "Remember your goal: ${goal.title}. Now get to work.",
      );
    } else {
      await showNotification(
        id: 2,
        title: "Empty Ambitions?",
        body: "You haven't even set a life goal yet. Start there.",
      );
    }
  }
}
