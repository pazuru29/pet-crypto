import 'package:flutter/material.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final AppTextStyle textStyle;
  final double spacing;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.textStyle = .bodySemibold,
    this.spacing = 8,
  }) : assert(
         text != null ||
             icon != null ||
             prefixIcon != null ||
             suffixIcon != null,
         'AppButton requires text or icon.',
       ),
       assert(
         icon == null || (prefixIcon == null && suffixIcon == null),
         'Use either icon or prefixIcon/suffixIcon, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? colorScheme.primary,
        foregroundColor: effectiveForegroundColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
      child: _ButtonContent(
        text: text,
        icon: icon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textStyle: textStyle,
        foregroundColor: effectiveForegroundColor,
        spacing: spacing,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final AppTextStyle textStyle;
  final Color foregroundColor;
  final double spacing;

  const _ButtonContent({
    required this.text,
    required this.icon,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.textStyle,
    required this.foregroundColor,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null && text == null) {
      return IconTheme.merge(
        data: IconThemeData(color: foregroundColor),
        child: icon!,
      );
    }

    return Row(
      mainAxisSize: .min,
      spacing: spacing,
      children: [
        if (icon != null || prefixIcon != null)
          IconTheme.merge(
            data: IconThemeData(color: foregroundColor),
            child: icon ?? prefixIcon!,
          ),
        if (text != null)
          AppText(
            text: text!,
            textStyle: textStyle,
            textColor: foregroundColor,
          ),
        if (suffixIcon != null)
          IconTheme.merge(
            data: IconThemeData(color: foregroundColor),
            child: suffixIcon!,
          ),
      ],
    );
  }
}
