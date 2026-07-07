import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/application/router/app_routes.dart';
import 'package:pet_crypto/widgets/app_title.dart';

class AppTitleProfile extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const AppTitleProfile({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
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
            color: Colors.grey.shade300,
          ),
          child: ClipRRect(
            borderRadius: .circular(100),
            child: imageUrl == null
                ? CircularProgressIndicator()
                : CachedNetworkImage(
                    imageUrl: imageUrl!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.person),
                  ),
          ),
        ),
      ),
    );
  }
}
