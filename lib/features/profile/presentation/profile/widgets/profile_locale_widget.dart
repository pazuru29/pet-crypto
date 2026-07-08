import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/widgets/app_text.dart';
import 'package:provider/provider.dart';

class ProfileLocaleWidget extends StatelessWidget {
  final Function(String?) onLanguageChoose;

  const ProfileLocaleWidget({super.key, required this.onLanguageChoose});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<S>();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: .only(left: 16, right: 16, top: 16),
      padding: .symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: .circular(10),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          AppText(
            text: S.of(context).profileLocalization,
            textStyle: AppTextStyle.bodyBold,
            textColor: colorScheme.onPrimaryContainer,
          ),
          DropdownMenu<String>(
            selectOnly: true,
            initialSelection: localeProvider.locale.languageCode,
            onSelected: onLanguageChoose,
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
              backgroundColor: WidgetStatePropertyAll(
                colorScheme.primaryContainer,
              ),
              surfaceTintColor: WidgetStatePropertyAll(colorScheme.onPrimary),
              side: WidgetStatePropertyAll(
                BorderSide(color: colorScheme.primary),
              ),
              elevation: WidgetStatePropertyAll(8),
            ),
            dropdownMenuEntries: S.supportedLocales.keys
                .map(
                  (e) => DropdownMenuEntry(
                    value: e,
                    label: e.toUpperCase(),
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
          ),
        ],
      ),
    );
  }
}
