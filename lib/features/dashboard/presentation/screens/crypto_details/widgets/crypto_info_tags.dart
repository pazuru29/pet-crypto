import 'package:flutter/material.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class CryptoInfoTags extends StatelessWidget {
  final List<String> tags;

  const CryptoInfoTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: .only(top: 16),
      child: SizedBox(
        height: 48,
        child: ListView.builder(
          shrinkWrap: true,
          padding: .only(left: 16, right: 12),
          scrollDirection: .horizontal,
          itemCount: tags.length,
          itemBuilder: (context, index) => Padding(
            padding: .only(right: 4),
            child: Chip(
              elevation: 1,
              shadowColor: Colors.black,
              surfaceTintColor: Colors.transparent,
              side: BorderSide(color: colorScheme.primary),
              label: AppText(
                text: tags[index],
                textStyle: .bodySemibold,
                textColor: colorScheme.onPrimaryContainer,
              ),
              color: WidgetStatePropertyAll(colorScheme.primaryContainer),
            ),
          ),
        ),
      ),
    );
  }
}
