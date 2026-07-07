import 'package:flutter/material.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onTryAgain;

  const ErrorView({super.key, required this.message, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          spacing: 16,
          children: [
            AppText(
              text: message ?? 'Something went wrong',
              textStyle: .headerSemibold,
              textColor: Theme.of(context).colorScheme.onSurface,
            ),
            AppButton(onPressed: onTryAgain, text: 'Try Again'),
          ],
        ),
      ),
    );
  }
}
