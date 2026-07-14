import 'package:flutter/material.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle textStyle;
  final Color? textColor;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final String? url;
  final VoidCallback? onTap;

  const AppText({
    super.key,
    required this.text,
    required this.textStyle,
    this.textColor,
    this.textOverflow,
    this.maxLines,
    this.textAlign,
  }) : url = null,
       onTap = null;

  const AppText.link({
    super.key,
    required this.url,
    required this.textStyle,
    required this.onTap,
    this.textColor,
    this.textOverflow,
    this.maxLines,
    this.textAlign,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: .opaque,
        child: Text(
          text.isEmpty ? url! : text,
          style: textStyle.style.copyWith(
            color: textColor,
            overflow: textOverflow,
            decoration: .underline,
          ),
          maxLines: maxLines,
          textAlign: textAlign,
        ),
      );
    }

    return Text(
      text,
      style: textStyle.style.copyWith(color: textColor, overflow: textOverflow),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
