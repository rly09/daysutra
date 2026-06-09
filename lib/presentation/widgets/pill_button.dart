import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Widget? icon;

  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      if (isPrimary) {
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon!,
          label: Text(label),
        );
      } else {
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon!,
          label: Text(label),
        );
      }
    } else {
      if (isPrimary) {
        return ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        );
      } else {
        return OutlinedButton(
          onPressed: onPressed,
          child: Text(label),
        );
      }
    }
  }
}
