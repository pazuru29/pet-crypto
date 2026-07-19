import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/widgets/error_view.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class ErrorView', () {
    testWidgets('should show localization (en) error', (tester) async {
      await pumpTestApp(
        tester,
        locale: Locale('en'),
        child: ErrorView(code: .storageFailure, onTryAgain: () {}),
      );

      final finderErrorView = find.byType(ErrorView);

      expect(finderErrorView, findsOneWidget);

      final element = tester.element(finderErrorView);

      expect(find.text(S.of(element).appErrorStorageFailure), findsOneWidget);
    });

    testWidgets('should show localization (uk) error', (tester) async {
      final app = await pumpTestApp(
        tester,
        locale: Locale('uk'),
        child: ErrorView(code: .storageFailure, onTryAgain: () {}),
      );

      expect(app.localization.locale.languageCode, 'uk');

      final finderErrorView = find.byType(ErrorView);

      expect(finderErrorView, findsOneWidget);

      final element = tester.element(finderErrorView);

      expect(find.text(S.of(element).appErrorStorageFailure), findsOneWidget);
    });

    testWidgets('should show error placeholder', (tester) async {
      await pumpTestApp(
        tester,
        locale: Locale('en'),
        child: ErrorView(code: null, onTryAgain: () {}),
      );

      final finderErrorView = find.byType(ErrorView);

      expect(finderErrorView, findsOneWidget);

      final element = tester.element(finderErrorView);

      expect(find.text(S.of(element).errorViewPlaceholder), findsOneWidget);
    });

    testWidgets('should show localization button try again', (tester) async {
      await pumpTestApp(
        tester,
        locale: Locale('en'),
        child: ErrorView(code: null, onTryAgain: () {}),
      );

      final finderErrorView = find.byType(ErrorView);

      expect(finderErrorView, findsOneWidget);

      final element = tester.element(finderErrorView);

      expect(find.text(S.of(element).errorViewTryAgain), findsOneWidget);
    });

    testWidgets('should call onTryAgain', (tester) async {
      int callCount = 0;

      await pumpTestApp(
        tester,
        locale: Locale('en'),
        child: ErrorView(
          code: null,
          onTryAgain: () {
            callCount++;
          },
        ),
      );

      final finderErrorView = find.byType(ErrorView);

      expect(finderErrorView, findsOneWidget);

      final element = tester.element(finderErrorView);

      final finderButton = find.text(S.of(element).errorViewTryAgain);

      expect(finderButton, findsOneWidget);

      await tester.tap(finderButton);

      expect(callCount, 1);
    });
  });
}
