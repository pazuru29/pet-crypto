import 'package:flutter/material.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';

class AppDropdownMenu<T> extends StatelessWidget {
  final T? initialSelection;
  final Function(T?)? onSelected;
  final List<T> entries;
  final String Function(T) labelBuilder;

  const AppDropdownMenu({
    super.key,
    required this.entries,
    required this.labelBuilder,
    this.initialSelection,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DropdownMenu<T>(
      selectOnly: true,
      initialSelection: initialSelection,
      onSelected: onSelected,
      alignmentOffset: Offset(0, 8),
      trailingIcon: Icon(
        Icons.keyboard_arrow_down,
        color: colorScheme.onPrimaryContainer,
      ),
      selectedTrailingIcon: Icon(
        Icons.keyboard_arrow_up,
        color: colorScheme.onPrimaryContainer,
      ),
      textStyle: AppTextStyle.bodySemibold.style.copyWith(
        color: colorScheme.onPrimaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.primaryContainer,
        enabledBorder: OutlineInputBorder(
          borderRadius: .circular(8),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
      menuStyle: MenuStyle(
        padding: WidgetStatePropertyAll(.zero),
        backgroundColor: WidgetStatePropertyAll(colorScheme.primaryContainer),
        surfaceTintColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        side: WidgetStatePropertyAll(BorderSide(color: colorScheme.primary)),
        elevation: WidgetStatePropertyAll(8),
      ),
      dropdownMenuEntries: entries
          .map(
            (e) => DropdownMenuEntry(
              value: e,
              label: labelBuilder(e),
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                  colorScheme.onPrimaryContainer,
                ),
                textStyle: WidgetStatePropertyAll(
                  AppTextStyle.bodySemibold.style.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
