import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBodyText extends StatelessWidget {
  final String label;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  const MyBodyText(
    this.label, {
    this.color,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.align = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    super.key,
  });

  /// ✅ Factory constructor with predefined values for SemiBold Bodytext
  factory MyBodyText.semiBold(
    String label, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    TextAlign? align,
    int? maxLines,
    Color? color,
    Key? key,
  }) {
    return MyBodyText(
      label,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      align: align,
      maxLines: maxLines,
      color: color,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      label.isNotEmpty ? label : '',
      textAlign: align,
      maxLines: maxLines ?? 2,
      overflow: overflow,
      style: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight, color: color),
    );
  }
}
