import 'package:flutter/material.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle textStyle;
  final Color? textColor;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const AppText({
    super.key,
    required this.text,
    required this.textStyle,
    this.textColor,
    this.textOverflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle.style.copyWith(color: textColor),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
