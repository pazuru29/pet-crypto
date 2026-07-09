import 'package:flutter/material.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class CryptoInfoDescription extends StatelessWidget {
  final String description;

  const CryptoInfoDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: .only(top: 16, right: 16, left: 16),
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: .symmetric(horizontal: 16, vertical: 8),
        child: AppText(
          text: description,
          textStyle: .bodySemibold,
          textColor: colorScheme.onPrimaryContainer,
          textAlign: .start,
        ),
      ),
    );
  }
}
