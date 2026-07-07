import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: .only(top: 16, right: 16, left: 16),
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
            padding: .only(top: 16, right: 16, left: 16),
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
            padding: .all(16),
            child: Shimmer(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: colorScheme.error,
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
