import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        AppText(
          text: message ?? 'Something went wrong',
          textStyle: .headerSemibold,
          textColor: Theme.of(context).colorScheme.error,
        ),
        ElevatedButton(
          onPressed: onTryAgain,
          child: AppText(text: 'Try Again', textStyle: .bodySemibold),
        ),
      ],
    );
  }
}
