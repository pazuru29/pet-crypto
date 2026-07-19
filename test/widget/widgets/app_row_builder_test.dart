import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/widgets/app_row_builder.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppRowBuilder', () {
    testWidgets('should call builder itemCount times', (tester) async {
      int callCount = 0;

      await pumpTestApp(
        tester,
        child: AppRowBuilder(
          itemCount: 3,
          builder: (context, index) {
            callCount++;
            return SizedBox.shrink();
          },
        ),
      );

      expect(callCount, 3);
    });

    testWidgets('builder should return index from 0 to (itemCount - 1)', (
      tester,
    ) async {
      final List<int> receivedIndices = [];

      await pumpTestApp(
        tester,
        child: AppRowBuilder(
          itemCount: 3,
          builder: (context, index) {
            receivedIndices.add(index);
            return SizedBox.shrink();
          },
        ),
      );

      expect(receivedIndices, List.generate(3, (index) => index));
    });

    testWidgets('should show all created elements', (tester) async {
      await pumpTestApp(
        tester,
        child: AppRowBuilder(
          itemCount: 3,
          builder: (context, index) {
            return Text('$index');
          },
        ),
      );

      for (var index in List.generate(3, (index) => index)) {
        expect(find.text('$index'), findsOneWidget);
      }
    });

    test('should throw AssertionError when itemCount < 2', () {
      expect(
        () => AppRowBuilder(itemCount: 1, builder: (_, _) => SizedBox.shrink()),
        throwsAssertionError,
      );
    });
  });
}
