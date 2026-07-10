import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    final Widget placeholder = _PlaceholderAppCachedImage(
      height: height,
      width: width,
      color: backgroundColor,
      icon: icon,
      iconPlaceHolderColor: iconPlaceHolderColor,
    );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? .circular(100),
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? .circular(100),
        child: needPlaceHolder || imageUrl == null
            ? placeholder
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: .contain,
                placeholder: (context, url) => placeholder,
                errorWidget: (context, url, error) => placeholder,
              ),
      ),
    );
  }
}

class _PlaceholderAppCachedImage extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Color iconPlaceHolderColor;
  final IconData icon;

  const _PlaceholderAppCachedImage({
    required this.height,
    required this.width,
    required this.color,
    required this.iconPlaceHolderColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: color),
      child: Icon(icon, color: iconPlaceHolderColor),
    );
  }
}
