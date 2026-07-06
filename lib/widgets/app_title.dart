import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class AppTitle extends StatelessWidget {
  final String title;
  final Widget? child;

  const AppTitle({super.key, required this.title, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              if (context.canPop())
                AppIconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () => context.pop(),
                ),
              AppText(
                text: title,
                textStyle: AppTextStyle.titleBold,
                textOverflow: .ellipsis,
              ),
            ],
          ),
          ?child,
        ],
      ),
    );
  }
}
