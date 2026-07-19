import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/widgets/app_pagination_loading.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppPaginationLoading', () {
    testWidgets('should show CircularProgressIndicator', (tester) async {
      await pumpTestApp(tester, child: AppPaginationLoading());

      final finderCircularIndicator = find.byType(CircularProgressIndicator);

      expect(finderCircularIndicator, findsOneWidget);
    });

    testWidgets('should have height 60', (tester) async {
      await pumpTestApp(tester, child: Scaffold(body: AppPaginationLoading()));

      final size = tester.getSize(find.byType(AppPaginationLoading));

      expect(size.height, 60);
    });

    testWidgets('should show small pagination indicator', (tester) async {
      await pumpTestApp(
        tester,
        child: const Scaffold(body: AppPaginationLoading()),
      );

      final finderCircularIndicator = find.byType(CircularProgressIndicator);

      expect(finderCircularIndicator, findsOneWidget);

      expect(tester.getSize(finderCircularIndicator), const Size(16, 16));

      final indicator = tester.widget<CircularProgressIndicator>(
        finderCircularIndicator,
      );

      expect(indicator.strokeWidth, 2.5);
    });
  });
}
