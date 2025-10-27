import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;
  final Color? color;
  final double size;
  final double? alpha;
  final bool enableHaptic;
  final EdgeInsets? padding;

  const MyIconButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 24,
    this.alpha,
    this.enableHaptic = false,
    super.key,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: size),
      onPressed: !enableHaptic
          ? onPressed
          : () {
              if (onPressed == null) return;
              HapticFeedback.lightImpact();
              onPressed!();
            },
      padding: padding ?? EdgeInsets.all(12.h),
      color: color ?? Colors.black,
    );
  }
}
