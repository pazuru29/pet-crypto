import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/widgets/app_cached_image.dart';
import 'package:pet_crypto/widgets/app_title_profile.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppTitleProfile', () {
    testWidgets('should show title and placeholder image', (tester) async {
      await pumpTestApp(
        tester,
        child: Scaffold(body: AppTitleProfile(title: 'Title', imageUrl: null)),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should set image to AppCachedImage', (tester) async {
      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppTitleProfile(
            title: 'Title',
            imageUrl: 'https://example.test',
          ),
        ),
      );

      final widget = tester.widget<AppCachedImage>(find.byType(AppCachedImage));

      expect(widget.imageUrl, 'https://example.test');
    });

    testWidgets('should open route profile and set imageUrl', (tester) async {
      await pumpTestRouter(
        tester,
        router: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: AppTitleProfile(
                  title: 'Title',
                  imageUrl: 'http://example.test',
                ),
              ),
              routes: [
                GoRoute(
                  path: '/profile',
                  name: 'profile',
                  builder: (context, state) => Scaffold(
                    body: Column(
                      children: [
                        Text('Profile'),
                        Text(state.uri.queryParameters['initUserImage'] ?? ''),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      final finderImage = find.byType(AppCachedImage);

      expect(finderImage, findsOneWidget);

      await tester.tap(finderImage);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('http://example.test'), findsOneWidget);
    });
  });
}
