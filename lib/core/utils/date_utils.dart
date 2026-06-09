import 'dart:math';
import 'package:intl/intl.dart';

class AppDateUtils {
  static String getFormattedDate() {
    return DateFormat('MMMM d, yyyy').format(DateTime.now());
  }

  static String getRandomGreeting() {
    final greetings = [
      "What is on your mind today?",
      "Capture today's thoughts.",
      "Let's shape your day.",
      "Every thought deserves a place.",
      "Reflect on your journey.",
      "Your second brain awaits."
    ];
    final random = Random();
    return greetings[random.nextInt(greetings.length)];
  }
}
