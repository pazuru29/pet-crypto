import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/app_error_code_localization_extension.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/core/errors/app_error_code.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class ErrorView extends StatelessWidget {
  final AppErrorCode? code;
  final VoidCallback onTryAgain;

  const ErrorView({super.key, required this.code, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          spacing: 16,
          children: [
            AppText(
              text: code?.localizedMessage(l10n) ?? l10n.errorViewPlaceholder,
              textStyle: .headerSemibold,
              textColor: Theme.of(context).colorScheme.onSurface,
              textAlign: .center,
            ),
            AppButton(onPressed: onTryAgain, text: l10n.errorViewTryAgain),
          ],
        ),
      ),
    );
  }
}
