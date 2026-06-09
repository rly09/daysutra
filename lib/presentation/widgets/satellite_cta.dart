import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SatelliteCTA extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final double size;

  const SatelliteCTA({
    super.key,
    required this.onTap,
    required this.icon,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000), // ~8% opacity shadow
              blurRadius: 24,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.inkBlack,
          size: size * 0.4,
        ),
      ),
    );
  }
}
