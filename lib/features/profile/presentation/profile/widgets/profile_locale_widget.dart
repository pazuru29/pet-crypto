import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/widgets/app_dropdown_menu.dart';
import 'package:pet_crypto/widgets/app_text.dart';
import 'package:provider/provider.dart';

class ProfileLocaleWidget extends StatelessWidget {
  final Function(String?) onLanguageChoose;

  const ProfileLocaleWidget({super.key, required this.onLanguageChoose});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<S>();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: .only(left: 16, right: 16, top: 16),
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: .symmetric(horizontal: 16, vertical: 8),
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
            AppDropdownMenu<String>(
              initialSelection: localeProvider.locale.languageCode,
              onSelected: onLanguageChoose,
              entries: S.supportedLocales.keys.toList(),
              labelBuilder: (languageCode) {
                return S.languageLabels[languageCode] ??
                    languageCode.toUpperCase();
              },
            ),
          ],
        ),
      ),
    );
  }
}
