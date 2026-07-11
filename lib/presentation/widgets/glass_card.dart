import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const GlassCard({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height,
    this.borderRadius = 40.0,
    this.padding = const EdgeInsets.all(24.0),
    this.onTap,
    this.onLongPress,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.05 : 0.4),
        (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.08 : 0.6),
      ],
    );

    Widget cardContent = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: linearGradient,
        border: Border.all(
          width: 1.5,
          color: (isDark ? Colors.white : AppColors.inkBlack).withValues(alpha: 0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: widget.padding,
            child: widget.child,
          ),
        ),
      ),
    );

    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.inkBlack).withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: cardContent,
    );

    Widget animatedCard = AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: card,
    );

    if (widget.onTap != null || widget.onLongPress != null) {
      return GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: animatedCard,
        ),
      );
    }
    return card;
  }
}
