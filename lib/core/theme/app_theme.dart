import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.inkBlack,
        onPrimary: AppColors.canvasCream,
        secondary: AppColors.lightSignalOrange,
        onSecondary: AppColors.white,
        error: AppColors.signalOrange,
        onError: AppColors.white,
        surface: AppColors.liftedCream,
        onSurface: AppColors.inkBlack,
      ),
      scaffoldBackgroundColor: AppColors.canvasCream,
      textTheme: AppTypography.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.inkBlack),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inkBlack,
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.canvasCream),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.liftedCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: AppTypography.textTheme.titleLarge,
        contentTextStyle: AppTypography.textTheme.bodyLarge,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.inkBlack,
          foregroundColor: AppColors.canvasCream,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.inkBlack, width: 1.5),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.inkBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: AppColors.inkBlack, width: 1.5),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: AppColors.inkBlack,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    // A dark mode interpretation of the warm aesthetic
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.canvasCream,
        onPrimary: AppColors.inkBlack,
        secondary: AppColors.lightSignalOrange,
        onSecondary: AppColors.white,
        error: AppColors.signalOrange,
        onError: AppColors.white,
        surface: Color(0xFF1E1E1C), // Slightly lifted warm dark
        onSurface: AppColors.canvasCream,
      ),
      scaffoldBackgroundColor: AppColors.inkBlack,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.canvasCream,
        displayColor: AppColors.canvasCream,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.canvasCream),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.canvasCream,
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.inkBlack),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E1E1C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(color: AppColors.canvasCream),
        contentTextStyle: AppTypography.textTheme.bodyLarge?.copyWith(color: AppColors.canvasCream),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.canvasCream,
          foregroundColor: AppColors.inkBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.canvasCream, width: 1.5),
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: AppColors.inkBlack,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.canvasCream,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: AppColors.canvasCream, width: 1.5),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: AppColors.canvasCream,
          ),
        ),
      ),
    );
  }
}
