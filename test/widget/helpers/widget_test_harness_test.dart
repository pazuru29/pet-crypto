import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'widget_test_harness.dart';

void main() {
  group('pumpTestApp', () {
    testWidgets('should show child', (tester) async {
      await pumpTestApp(
        tester,
        child: const Scaffold(body: Text('Test child')),
      );

      expect(find.text('Test child'), findsOneWidget);
    });

    testWidgets('should use selected locale', (tester) async {
      await pumpTestApp(
        tester,
        locale: const Locale('ru'),
        child: Builder(
          builder: (context) {
            return Text(Localizations.localeOf(context).languageCode);
          },
        ),
      );

      expect(find.text('ru'), findsOneWidget);
    });

    testWidgets('should use dark theme', (tester) async {
      await pumpTestApp(
        tester,
        themeMode: ThemeMode.dark,
        child: Builder(
          builder: (context) {
            return Text(Theme.of(context).brightness.name);
          },
        ),
      );

      expect(find.text('dark'), findsOneWidget);
    });

    testWidgets('should use selected viewport', (tester) async {
      late Size actualSize;

      await pumpTestApp(
        tester,
        viewport: const Size(390, 844),
        child: Builder(
          builder: (context) {
            actualSize = MediaQuery.sizeOf(context);
            return const SizedBox();
          },
        ),
      );

      expect(actualSize, const Size(390, 844));
    });

    testWidgets('should rebuild after locale change', (tester) async {
      final app = await pumpTestApp(
        tester,
        child: Builder(
          builder: (context) {
            return Text(Localizations.localeOf(context).languageCode);
          },
        ),
      );

      expect(find.text('en'), findsOneWidget);

      await app.localization.setLocale('uk');
      await tester.pump();

      expect(find.text('uk'), findsOneWidget);
    });

    testWidgets('should rebuild after theme change', (tester) async {
      final app = await pumpTestApp(
        tester,
        child: Builder(
          builder: (context) {
            return Text(Theme.of(context).brightness.name);
          },
        ),
      );

      expect(find.text('light'), findsOneWidget);

      await app.theme.setMode(ThemeMode.dark.index);
      await tester.pumpAndSettle();

      expect(find.text('dark'), findsOneWidget);
    });
  });

  group('pumpTestRouter', () {
    testWidgets('should navigate between routes', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => context.go('/details'),
                  child: const Text('Open details'),
                ),
              );
            },
          ),
          GoRoute(
            path: '/details',
            builder: (context, state) {
              return const Scaffold(body: Text('Details'));
            },
          ),
        ],
      );

      await pumpTestRouter(tester, router: router);

      expect(find.text('Open details'), findsOneWidget);

      await tester.tap(find.text('Open details'));
      await tester.pumpAndSettle();

      expect(find.text('Details'), findsOneWidget);
    });
  });
}
