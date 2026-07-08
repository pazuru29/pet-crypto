import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/application/router/app_routes.dart';
import 'package:pet_crypto/core/util/app_hero_tags.dart';
import 'package:pet_crypto/widgets/app_title.dart';
import 'package:pet_crypto/widgets/profile_image.dart';

class AppTitleProfile extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool placeHolder;

  const AppTitleProfile({
    super.key,
    required this.title,
    required this.imageUrl,
    this.placeHolder = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppTitle(
      title: title,
      child: InkWell(
        borderRadius: .circular(100),
        onTap: () => context.pushNamed(
          AppRoutes.profile.name,
          queryParameters: {'initUserImage': imageUrl},
        ),
        child: Hero(
          tag: AppHeroTags.profileImageTag,
          child: ProfileImage(
            height: 40,
            width: 40,
            backgroundColor: colorScheme.primaryContainer,
            needPlaceHolder: placeHolder,
            iconPlaceHolderColor: colorScheme.primary,
            imageUrl: imageUrl,
          ),
        ),
      ),
    );
  }
}
