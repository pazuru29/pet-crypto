import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/widgets/loading_view.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class LoadingView', () {
    testWidgets('should show CircularProgressIndicator', (tester) async {
      await pumpTestApp(tester, child: LoadingView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
