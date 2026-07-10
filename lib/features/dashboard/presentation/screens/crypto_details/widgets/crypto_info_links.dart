import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class CryptoInfoLinks extends StatelessWidget {
  final List<String>? website;
  final List<String>? technicalDoc;
  final List<String>? sourceCode;
  final Function(String)? onLinkTap;

  const CryptoInfoLinks({
    super.key,
    this.website,
    this.technicalDoc,
    this.sourceCode,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: .all(16),
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: .symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            if (website?.isNotEmpty == true)
              _TitleList(
                title: S.of(context).cryptoDetailsWebsite,
                list: website!,
                onLinkTap: onLinkTap,
              ),
            if (technicalDoc?.isNotEmpty == true)
              _TitleList(
                title: S.of(context).cryptoDetailsTechnicalDoc,
                list: technicalDoc!,
                onLinkTap: onLinkTap,
              ),
            if (sourceCode?.isNotEmpty == true)
              _TitleList(
                title: S.of(context).cryptoDetailsSourceCode,
                list: sourceCode!,
                onLinkTap: onLinkTap,
              ),
          ],
        ),
      ),
    );
  }
}

class _TitleList extends StatelessWidget {
  final String title;
  final List<String> list;
  final Function(String)? onLinkTap;

  const _TitleList({
    required this.title,
    required this.list,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        AppText(
          text: title,
          textStyle: .headerSemibold,
          textColor: colorScheme.onPrimaryContainer,
        ),
        for (var link in list)
          AppText.link(
            url: link,
            textStyle: .headerSemibold,
            textColor: colorScheme.primary,
            onTap: onLinkTap == null ? null : () => onLinkTap!(link),
          ),
      ],
    );
  }
}
