import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final isDarkProvider = StateProvider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == ThemeMode.dark) return true;
  if (themeMode == ThemeMode.light) return false;
  return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
});

