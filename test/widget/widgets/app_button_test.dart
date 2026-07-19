import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/widgets/app_button.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppButton', () {
    testWidgets('should show text on button', (tester) async {
      await pumpTestApp(
        tester,
        child: AppButton(text: 'Press', onPressed: null),
      );

      expect(find.text('Press'), findsOneWidget);
    });

    testWidgets('should show icon on button', (tester) async {
      await pumpTestApp(
        tester,
        child: AppButton(icon: Icon(Icons.check), onPressed: null),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should show prefixIcon, text and suffixIcon on button', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        child: AppButton(
          prefixIcon: Icon(Icons.check),
          suffixIcon: Icon(Icons.close),
          text: 'Press',
          onPressed: null,
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Press'), findsOneWidget);
    });

    testWidgets('should after press call onPressed', (tester) async {
      int callCount = 0;

      await pumpTestApp(
        tester,
        child: AppButton(
          text: 'Press',
          onPressed: () {
            callCount++;
          },
        ),
      );

      await tester.tap(find.text('Press'));

      expect(callCount, 1);
    });

    testWidgets('should be disable when onPressed is null', (tester) async {
      await pumpTestApp(
        tester,
        child: AppButton(text: 'Press', onPressed: null),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button.onPressed, isNull);
      expect(button.enabled, isFalse);
    });

    test('should throw AssertionError when nothing select', () {
      expect(() => AppButton(onPressed: null), throwsAssertionError);
    });

    test(
      'should throw AssertionError when set icon and prefixIcon and suffixIcon',
      () {
        expect(
          () => AppButton(
            icon: Icon(Icons.person),
            prefixIcon: Icon(Icons.check),
            suffixIcon: Icon(Icons.close),
            onPressed: null,
          ),
          throwsAssertionError,
        );
      },
    );
  });
}
