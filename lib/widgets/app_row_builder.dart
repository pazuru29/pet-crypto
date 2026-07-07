import 'package:flutter/material.dart';

class AppRowBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) builder;

  const AppRowBuilder({
    super.key,
    required this.itemCount,
    required this.builder,
  }) : assert(itemCount >= 2, 'AppSelectedButton requires itemCount over 2');

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: .circular(8),
        border: .all(color: colorScheme.outline),
      ),
      child: ClipRRect(
        borderRadius: .circular(7),
        child: Row(
          mainAxisSize: .min,
          children: [
            for (var index = 0; index < itemCount; index++)
              if (index < (itemCount - 1))
                Container(
                  decoration: BoxDecoration(
                    border: .fromLTRB(
                      right: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  child: builder(context, index),
                )
              else
                builder(context, index),
          ],
        ),
      ),
    );
  }
}
