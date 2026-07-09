import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AppCachedImage extends StatelessWidget {
  final double height;
  final double width;
  final Color backgroundColor;
  final bool needPlaceHolder;
  final Color iconPlaceHolderColor;
  final IconData icon;
  final String? imageUrl;
  final BorderRadius? borderRadius;

  const AppCachedImage({
    super.key,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.needPlaceHolder,
    required this.iconPlaceHolderColor,
    required this.icon,
    this.imageUrl,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? .circular(100),
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? .circular(100),
        child: needPlaceHolder
            ? Icon(icon, color: iconPlaceHolderColor)
            : imageUrl == null
            ? _LoadingAppCachedImage(
                height: height,
                width: width,
                color: backgroundColor,
              )
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: .contain,
                placeholder: (context, url) => _LoadingAppCachedImage(
                  height: height,
                  width: width,
                  color: backgroundColor,
                ),
                errorWidget: (context, url, error) =>
                    Icon(icon, color: iconPlaceHolderColor),
              ),
      ),
    );
  }
}

class _LoadingAppCachedImage extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const _LoadingAppCachedImage({
    required this.height,
    required this.width,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: color),
      ),
    );
  }
}
