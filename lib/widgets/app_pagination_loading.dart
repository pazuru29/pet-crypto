import 'package:flutter/material.dart';

class AppPaginationLoading extends StatelessWidget {
  const AppPaginationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 60,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: .circular(100),
            boxShadow: [BoxShadow(color: colorScheme.outline, spreadRadius: 1)],
          ),
          child: CircularProgressIndicator(
            strokeWidth: 1,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
