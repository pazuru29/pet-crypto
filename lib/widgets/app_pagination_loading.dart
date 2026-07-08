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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: .circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 0.2,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
