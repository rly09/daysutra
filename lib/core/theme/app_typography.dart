import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.sofiaSans(
      fontSize: 64,
      fontWeight: FontWeight.w500,
      height: 1.0,
      letterSpacing: -1.28,
      color: AppColors.inkBlack,
    ),
    displayMedium: GoogleFonts.sofiaSans(
      fontSize: 36,
      fontWeight: FontWeight.w500,
      height: 1.22, // ~44px
      letterSpacing: -0.72,
      color: AppColors.inkBlack,
    ),
    titleLarge: GoogleFonts.sofiaSans(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      height: 1.2, // 28.8px
      letterSpacing: -0.48,
      color: AppColors.inkBlack,
    ),
    titleMedium: GoogleFonts.sofiaSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.3,
      letterSpacing: 0,
      color: AppColors.inkBlack,
    ),
    titleSmall: GoogleFonts.sofiaSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.0,
      letterSpacing: 0.56,
      color: AppColors.inkBlack,
    ), // Eyebrow
    bodyLarge: GoogleFonts.sofiaSans(
      fontSize: 16,
      fontWeight: FontWeight.w400, // Ideally 450, using 400 with tighter spacing
      height: 1.4, // 22.4px
      letterSpacing: -0.08, // Slightly tighter to simulate 450 weight
      color: AppColors.inkBlack,
    ),
    bodyMedium: GoogleFonts.sofiaSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
      letterSpacing: 0,
      color: AppColors.slateGray,
    ),
    labelLarge: GoogleFonts.sofiaSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      letterSpacing: -0.48,
      color: AppColors.white, // Default for primary button
    ),
  );
}
