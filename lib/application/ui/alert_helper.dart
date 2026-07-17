import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/app_error_code_localization_extension.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/ui/bloc_message_colors.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class AlertHelper {
  static void showSnackBar(BuildContext context, BlocMessage message) {
    Color foregroundColor = message.type.foregroundColor(context);
    Color backgroundColor = message.type.backgroundColor(context);
    Duration duration = const Duration(seconds: 3);
    final text = message.code.localizedMessage(S.of(context));

    SnackBar snackBar = SnackBar(
      duration: duration,
      width: null,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: foregroundColor,
      content: AppText(
        text: text,
        textStyle: AppTextStyle.bodySemibold,
        textColor: foregroundColor,
      ),
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showBanner(BuildContext context, BlocMessage message) {
    final messenger = ScaffoldMessenger.of(context);
    final foregroundColor = message.type.foregroundColor(context);
    final backgroundColor = message.type.backgroundColor(context);
    final text = message.code.localizedMessage(S.of(context));

    Timer? timer;

    late final ScaffoldFeatureController<
      MaterialBanner,
      MaterialBannerClosedReason
    >
    controller;

    final banner = MaterialBanner(
      leading: Icon(Icons.info_outline, color: foregroundColor, size: 20),
      content: AppText(
        text: text,
        textStyle: AppTextStyle.bodySemibold,
        textColor: foregroundColor,
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      actions: [
        AppIconButton.icon(
          icon: Icons.close,
          iconColor: foregroundColor,
          onPressed: () {
            timer?.cancel();
            controller.close();
          },
        ),
      ],
    );

    messenger.removeCurrentMaterialBanner();
    controller = messenger.showMaterialBanner(banner);

    timer = Timer(const Duration(seconds: 3), controller.close);

    controller.closed.whenComplete(() {
      timer?.cancel();
    });
  }
}
