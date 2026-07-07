import 'package:flutter/material.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/widgets/app_text.dart';
import 'package:pet_crypto/widgets/profile_image.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String? initUserImage;
  final String? profileImage;
  final String? fullName;
  final bool needPlaceHolder;

  const ProfileHeaderWidget({
    super.key,
    required this.initUserImage,
    required this.profileImage,
    required this.fullName,
    required this.needPlaceHolder,
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
          Hero(
            tag: 'profileImage',
            child: ProfileImage(
              height: 80,
              width: 80,
              backgroundColor: colorScheme.primaryContainer,
              needPlaceHolder: needPlaceHolder,
              iconPlaceHolderColor: colorScheme.primary,
              imageUrl: profileImage ?? initUserImage,
            ),
          ),
          AppText(
            text: fullName ?? '',
            textStyle: AppTextStyle.headerBold,
            textColor: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
