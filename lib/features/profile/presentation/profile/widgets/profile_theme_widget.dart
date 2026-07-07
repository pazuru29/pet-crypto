import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/util/app_icons.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/app_row_builder.dart';
import 'package:pet_crypto/widgets/app_text.dart';
import 'package:provider/provider.dart';

class ProfileThemeWidget extends StatefulWidget {
  final Function(int) onButtonPressed;

  const ProfileThemeWidget({super.key, required this.onButtonPressed});

  @override
  State<ProfileThemeWidget> createState() => _ProfileThemeWidgetState();
}

class _ProfileThemeWidgetState extends State<ProfileThemeWidget> {
  final List<String> listOfThemeIcons = [
    AppIcons.icSystem,
    AppIcons.icSun,
    AppIcons.icMoon,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: .only(left: 16, right: 16, top: 16),
      padding: .symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: .circular(10),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          AppText(
            text: S.of(context).profileTheme,
            textStyle: AppTextStyle.bodyBold,
            textColor: colorScheme.onPrimaryContainer,
          ),
          AppRowBuilder(
            itemCount: ThemeMode.values.length,
            builder: (context, index) {
              bool isSelected = themeProvider.mode.index == index;
              return AppIconButton.svgIcon(
                padding: .all(12),
                borderRadius: .zero,
                svgIcon: listOfThemeIcons[index],
                backgroundColor: isSelected
                    ? colorScheme.primary
                    : Colors.transparent,
                iconColor: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onPrimaryContainer,
                highlightColor: colorScheme.primary.withValues(alpha: 0.3),
                splashColor: colorScheme.primary.withValues(alpha: 0.3),
                onPressed: () => widget.onButtonPressed(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
