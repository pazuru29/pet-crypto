import 'package:flutter/material.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/crypto_details/widgets/crypto_info_description.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/crypto_details/widgets/crypto_info_header.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/crypto_details/widgets/crypto_info_links.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/crypto_details/widgets/crypto_info_tags.dart';

class CryptoInfoView extends StatelessWidget {
  final CryptoInfo info;
  final Function(String)? onLinkTap;

  const CryptoInfoView({super.key, required this.info, this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CryptoInfoHeader(
            name: info.name,
            symbol: info.symbol,
            logo: info.logo,
          ),
        ),
        if (info.tags?.isNotEmpty == true)
          SliverToBoxAdapter(child: CryptoInfoTags(tags: info.tags!)),
        if (info.description != null)
          SliverToBoxAdapter(
            child: CryptoInfoDescription(description: info.description!),
          ),
        if (info.website?.isNotEmpty == true ||
            info.technicalDoc?.isNotEmpty == true ||
            info.sourceCode?.isNotEmpty == true)
          SliverToBoxAdapter(
            child: CryptoInfoLinks(
              website: info.website,
              technicalDoc: info.technicalDoc,
              sourceCode: info.sourceCode,
              onLinkTap: onLinkTap,
            ),
          ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ),
      ],
    );
  }
}
