import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CryptoDetailsLoadingView extends StatelessWidget {
  const CryptoDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: .only(bottom: MediaQuery.paddingOf(context).bottom),
      child: Column(
        children: [
          Shimmer(
            child: Container(
              height: 180,
              decoration: BoxDecoration(color: colorScheme.primary),
            ),
          ),
          Padding(
            padding: .only(left: 16, right: 16, top: 16),
            child: Shimmer(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: .circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: .only(left: 16, right: 16, top: 16),
            child: Shimmer(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: .circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
