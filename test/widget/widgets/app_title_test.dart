import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/app_title.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppTitle', () {
    testWidgets('should show title', (tester) async {
      await pumpTestApp(tester, child: AppTitle(title: 'Dashboard'));

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('should show child', (tester) async {
      await pumpTestApp(
        tester,
        child: AppTitle(title: 'Dashboard', child: Icon(Icons.check)),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should don\'t show back button', (tester) async {
      await pumpTestApp(
        tester,
        child: AppTitle(title: 'Dashboard', secondary: false),
      );

      expect(find.byType(AppIconButton), findsNothing);
    });

    testWidgets('should show back button', (tester) async {
      await pumpTestApp(
        tester,
        child: AppTitle(title: 'Dashboard', secondary: true),
      );

      expect(find.byType(AppIconButton), findsOneWidget);
    });

    testWidgets('tap on back button should return to first screen', (
      tester,
    ) async {
      await pumpTestRouter(
        tester,
        router: GoRouter(
          initialLocation: '/next',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(body: Text('Main Screen')),
              routes: [
                GoRoute(
                  path: '/next',
                  builder: (context, state) =>
                      AppTitle(title: 'Title', secondary: true),
                ),
              ],
            ),
          ],
        ),
      );

      final finderIconButton = find.byType(AppIconButton);

      expect(finderIconButton, findsOneWidget);

      await tester.tap(finderIconButton);
      await tester.pumpAndSettle();

      expect(find.text('Main Screen'), findsOneWidget);
    });
  });
}
