import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/widgets/app_text.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppText', () {
    testWidgets('should show text', (tester) async {
      await pumpTestApp(
        tester,
        child: AppText(text: 'Hello', textStyle: .bodyRegular),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('should show link when text is null', (tester) async {
      await pumpTestApp(
        tester,
        child: AppText.link(
          url: 'https://example.test',
          textStyle: .bodyRegular,
          onTap: null,
        ),
      );

      expect(find.text('https://example.test'), findsOneWidget);
    });

    testWidgets('should show text when link has text', (tester) async {
      await pumpTestApp(
        tester,
        child: AppText.link(
          text: 'Example URL',
          url: 'https://example.test',
          textStyle: .bodyRegular,
          onTap: null,
        ),
      );

      expect(find.text('Example URL'), findsOneWidget);
    });

    testWidgets('should call onTap', (tester) async {
      int callCount = 0;

      await pumpTestApp(
        tester,
        child: AppText.link(
          text: 'Title',
          url: 'https://example.test',
          textStyle: .bodyRegular,
          onTap: () {
            callCount++;
          },
        ),
      );

      await tester.tap(find.text('Title'));

      expect(callCount, 1);
    });

    testWidgets('should set maxLines and textAlign', (tester) async {
      await pumpTestApp(
        tester,
        child: AppText(
          text: 'Title',
          textStyle: .bodyRegular,
          maxLines: 10,
          textAlign: .right,
        ),
      );

      final textFinder = find.text('Title');

      expect(textFinder, findsOneWidget);

      final widget = tester.widget<Text>(textFinder);

      expect(widget.maxLines, 10);
      expect(widget.textAlign, TextAlign.right);
    });
  });
}
