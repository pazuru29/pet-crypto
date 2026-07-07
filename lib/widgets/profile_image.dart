import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProfileImage extends StatelessWidget {
  final double height;
  final double width;
  final Color backgroundColor;
  final bool needPlaceHolder;
  final Color iconPlaceHolderColor;
  final String? imageUrl;

  const ProfileImage({
    super.key,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.needPlaceHolder,
    required this.iconPlaceHolderColor,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: .circular(100),
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: .circular(100),
        child: needPlaceHolder
            ? Icon(Icons.person, color: iconPlaceHolderColor)
            : imageUrl == null
            ? _LoadingProfileImage(height: height, width: width)
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: .contain,
                placeholder: (context, url) =>
                    _LoadingProfileImage(height: height, width: width),
                errorWidget: (context, url, error) =>
                    Icon(Icons.person, color: iconPlaceHolderColor),
              ),
      ),
    );
  }
}

class _LoadingProfileImage extends StatelessWidget {
  final double height;
  final double width;

  const _LoadingProfileImage({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Colors.grey.shade300),
      ),
    );
  }
}
