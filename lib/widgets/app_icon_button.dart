import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIconButton extends StatelessWidget {
  final IconData? icon;
  final String? svgIcon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? iconColor;
  final Border? border;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final String? tooltip;

  const AppIconButton._({
    super.key,
    required this.onPressed,
    this.icon,
    this.svgIcon,
    this.backgroundColor = Colors.transparent,
    this.highlightColor,
    this.splashColor,
    this.iconColor,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.all(8),
    this.tooltip,
  });

  const AppIconButton.icon({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    Color backgroundColor = Colors.transparent,
    Color? highlightColor,
    Color? splashColor,
    Color? iconColor,
    Border? border,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
    String? tooltip,
  }) : this._(
         key: key,
         icon: icon,
         onPressed: onPressed,
         backgroundColor: backgroundColor,
         highlightColor: highlightColor,
         splashColor: splashColor,
         iconColor: iconColor,
         border: border,
         borderRadius: borderRadius,
         padding: padding,
         tooltip: tooltip,
       );

  const AppIconButton.svgIcon({
    Key? key,
    required String svgIcon,
    required VoidCallback? onPressed,
    Color backgroundColor = Colors.transparent,
    Color? highlightColor,
    Color? splashColor,
    Color? iconColor,
    Border? border,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
    String? tooltip,
  }) : this._(
         key: key,
         svgIcon: svgIcon,
         onPressed: onPressed,
         backgroundColor: backgroundColor,
         highlightColor: highlightColor,
         splashColor: splashColor,
         iconColor: iconColor,
         border: border,
         borderRadius: borderRadius,
         padding: padding,
         tooltip: tooltip,
       );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final button = Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: borderRadius,
        ),
        child: InkWell(
          onTap: onPressed,
          splashColor:
              splashColor ?? colorScheme.primary.withValues(alpha: 0.5),
          highlightColor: highlightColor ?? colorScheme.primaryContainer,
          borderRadius: borderRadius,
          child: Padding(
            padding: padding,
            child: icon != null
                ? Icon(icon, color: iconColor)
                : SvgPicture.asset(
                    svgIcon!,
                    colorFilter: iconColor != null
                        ? ColorFilter.mode(iconColor!, .srcIn)
                        : null,
                  ),
          ),
        ),
      ),
    );

    if (tooltip == null) {
      return button;
    }

    return Tooltip(message: tooltip!, child: button);
  }
}
