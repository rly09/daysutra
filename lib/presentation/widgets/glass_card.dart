import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 40.0,
    this.padding = const EdgeInsets.all(24.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.inkBlack).withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: GlassmorphicContainer(
        width: width,
        height: height,
        borderRadius: borderRadius,
        blur: 20,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.05 : 0.4),
            (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.05 : 0.4),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: isDark ? 0.1 : 0.05),
            (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: card,
        ),
      );
    }
    return card;
  }
}
