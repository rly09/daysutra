import 'dart:io';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/todo_task.dart';
import '../../domain/models/life_goal.dart';
import '../../data/repositories/hive_repository.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<String> _sarcasticMessages = [
    "Oh, look who's still got tasks. 9 PM and you're already giving up?",
    "Your todo list is crying. Do you enjoy being unproductive?",
    "Another day, another set of incomplete goals. Consistency is key, I guess?",
    "I'd remind you to finish your tasks, but we both know you're 'too busy' scrolling.",
    "Is 'procrastination' a life goal of yours? Because you're winning.",
    "Tick tock. 9 PM. Your tasks are still there. Just like your unfulfilled potential.",
  ];

  final List<String> _congratsMessages = [
    "You actually did it! All tasks completed today. Color me impressed.",
    "Look at you, being all productive! All tasks done for the day.",
    "Zero tasks remaining. You earned a break (or a cookie).",
    "Clean sweep! You've checked off every single task today.",
    "All tasks completed! DaySutra approved efficiency.",
  ];

  Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      final String timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint("Error getting timezone, falling back to UTC: $e");
      // Fallback to UTC if timezone detection fails
      tz.setLocalLocation(tz.UTC);
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(settings: initializationSettings);

    await requestPermission();
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final bool notificationGranted =
          await androidPlugin?.requestNotificationsPermission() ?? false;
      
      try {
        await androidPlugin?.requestExactAlarmsPermission();
      } catch (e) {
        debugPrint("Error requesting exact alarm permission: $e");
      }
      
      return notificationGranted;
    } else if (Platform.isIOS) {
      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return false;
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

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

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
    final incompleteCount = tasksBox.values
        .where((task) => !task.isCompleted)
        .length;

    if (incompleteCount > 0) {
      final random = Random();
      final message =
          _sarcasticMessages[random.nextInt(_sarcasticMessages.length)];
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

  Future<void> showCongratsNotification() async {
    final random = Random();
    final message = _congratsMessages[random.nextInt(_congratsMessages.length)];
    await showNotification(id: 3, title: "All Tasks Done! 🎉", body: message);
  }

  Future<void> scheduleDailyLifeGoalReminder() async {
    if (!Hive.isBoxOpen(HiveRepository.goalsBoxName)) {
      await Hive.openBox<LifeGoal>(HiveRepository.goalsBoxName);
    }

    final goalsBox = Hive.box<LifeGoal>(HiveRepository.goalsBoxName);
    String title = "Morning Motivation";
    String body = "You haven't even set a life goal yet. Start there.";

    if (goalsBox.isNotEmpty) {
      final goal = goalsBox.values.first;
      body = "Remember your goal: ${goal.title}. Now get to work.";
    }

    await _scheduleDailyNotification(
      id: 2,
      title: title,
      body: body,
      hour: 8,
      minute: 0,
    );
  }

  Future<void> scheduleDailySarcasticReminder() async {
    if (!Hive.isBoxOpen(HiveRepository.tasksBoxName)) {
      await Hive.openBox<TodoTask>(HiveRepository.tasksBoxName);
    }

    final tasksBox = Hive.box<TodoTask>(HiveRepository.tasksBoxName);
    final incompleteCount = tasksBox.values
        .where((task) => !task.isCompleted)
        .length;

    if (incompleteCount > 0) {
      final random = Random();
      final message =
          _sarcasticMessages[random.nextInt(_sarcasticMessages.length)];

      await _scheduleDailyNotification(
        id: 1,
        title: "Still Slacking?",
        body: "$message ($incompleteCount tasks left)",
        hour: 21,
        minute: 0,
      );
    } else {
      // Cancel the scheduled reminder if there are no incomplete tasks
      await _notificationsPlugin.cancel(id: 1);
    }
  }

  Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'daysutra_scheduled_reminders',
          'DaySutra Scheduled Reminders',
          channelDescription: 'Scheduled daily reminders',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint("Failed to schedule exact alarm: $e. Falling back to inexact.");
      try {
        await _notificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (ex) {
        debugPrint("Failed to schedule inexact alarm: $ex");
      }
    }
  }
}
