import 'package:flutter/material.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';

class AppTextFormFiled extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;

  const AppTextFormFiled({
    super.key,
    this.controller,
    this.validator,
    this.keyboardType,
    this.autofillHints,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      obscureText: obscureText,
      style: AppTextStyle.bodySemibold.style.copyWith(
        color: colorScheme.secondary,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        errorMaxLines: 2,
        labelStyle: AppTextStyle.hintSemibold.style.copyWith(
          color: colorScheme.secondary,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
          borderRadius: .circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primaryContainer),
          borderRadius: .circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
          borderRadius: .circular(10),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: .all(14),
        isCollapsed: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
