import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pet_crypto/core/ui/bloc_message_colors.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class AlertHelper {
  static Timer? _timer;

  static void showSnackBar(BuildContext context, BlocMessage message) {
    Color foregroundColor = message.type.foregroundColor(context);
    Color backgroundColor = message.type.backgroundColor(context);
    Duration duration = const Duration(seconds: 3);

    SnackBar snackBar = SnackBar(
      duration: duration,
      width: null,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: foregroundColor,
      content: AppText(
        text: message.text,
        textStyle: AppTextStyle.bodySemibold,
        textColor: foregroundColor,
      ),
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showBanner(BuildContext context, BlocMessage message) {
    Color foregroundColor = message.type.foregroundColor(context);
    Color backgroundColor = message.type.backgroundColor(context);

    List<Widget> actions = [];

    actions.add(
      AppIconButton.icon(
        icon: Icons.close,
        iconColor: foregroundColor,
        splashColor: foregroundColor,
        highlightColor: message.type
            .backgroundColor(context)
            .withValues(alpha: 0.5),
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        },
      ),
    );

    Widget? leadingIcon = Icon(
      Icons.info_outline,
      color: foregroundColor,
      size: 20,
    );

    MaterialBanner banner = MaterialBanner(
      content: AppText(
        text: message.text,
        textStyle: AppTextStyle.bodySemibold,
        textColor: foregroundColor,
      ),
      padding: .symmetric(horizontal: 24),
      leading: leadingIcon,
      actions: actions,
      overflowAlignment: OverflowBarAlignment.center,
      forceActionsBelow: false,
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showMaterialBanner(banner);

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }
}
