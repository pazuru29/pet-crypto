import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/widgets/app_cached_image.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppCachedImage', () {
    testWidgets('should show placeholder when url is null', (tester) async {
      await pumpTestApp(
        tester,
        child: AppCachedImage(
          height: 100,
          width: 100,
          backgroundColor: Colors.black,
          needPlaceHolder: false,
          iconPlaceHolderColor: Colors.grey,
          icon: Icons.check,
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should set size', (tester) async {
      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppCachedImage(
            height: 100,
            width: 100,
            backgroundColor: Colors.black,
            needPlaceHolder: false,
            iconPlaceHolderColor: Colors.grey,
            icon: Icons.check,
          ),
        ),
      );

      final finderAppCachedImage = find.byType(AppCachedImage);

      expect(finderAppCachedImage, findsOneWidget);

      expect(tester.getSize(finderAppCachedImage), const Size(100, 100));
    });

    testWidgets('should show placeholder when needPlaceHolder is true', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        child: AppCachedImage(
          needPlaceHolder: true,
          imageUrl: 'https://exaple.test',
          height: 100,
          width: 100,
          backgroundColor: Colors.black,
          iconPlaceHolderColor: Colors.grey,
          icon: Icons.check,
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
