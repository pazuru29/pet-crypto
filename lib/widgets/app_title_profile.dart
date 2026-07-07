import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/application/router/app_routes.dart';
import 'package:pet_crypto/widgets/app_title.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
        onTap: () => context.push(AppRoutes.profile.path),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: .circular(100),
            color: colorScheme.primaryContainer,
          ),
          child: ClipRRect(
            borderRadius: .circular(100),
            child: placeHolder
                ? Icon(Icons.person, color: colorScheme.primary)
                : imageUrl == null
                ? const _LoadingProfileImage()
                : CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: .contain,
                    placeholder: (context, url) => const _LoadingProfileImage(),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.person, color: colorScheme.primary),
                  ),
          ),
        ),
      ),
    );
  }
}

class _LoadingProfileImage extends StatelessWidget {
  const _LoadingProfileImage();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(color: Colors.grey.shade300),
      ),
    );
  }
}
