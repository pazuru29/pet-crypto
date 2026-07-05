import 'package:flutter/material.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class DashboardErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onTryAgain;

  const DashboardErrorView({
    super.key,
    required this.onTryAgain,
    required this.message,
  });

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
