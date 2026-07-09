import 'package:flutter/material.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/widgets/app_cached_image.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class CryptoInfoHeader extends StatelessWidget {
  final String name;
  final String symbol;
  final String? logo;

  const CryptoInfoHeader({
    super.key,
    required this.name,
    required this.symbol,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 180,
      decoration: BoxDecoration(color: colorScheme.primary),
      child: Column(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          AppCachedImage(
            height: 80,
            width: 80,
            backgroundColor: colorScheme.primaryContainer,
            needPlaceHolder: logo == null,
            iconPlaceHolderColor: colorScheme.onPrimaryContainer,
            icon: Icons.monetization_on_outlined,
            imageUrl: logo,
          ),
          AppText(
            text: '$name ($symbol)',
            textStyle: AppTextStyle.headerBold,
            textColor: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
