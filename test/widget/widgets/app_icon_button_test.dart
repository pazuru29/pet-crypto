import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/core/util/app_icons.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppIconButton', () {
    testWidgets('should show icon', (tester) async {
      await pumpTestApp(
        tester,
        child: AppIconButton.icon(icon: Icons.check, onPressed: null),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should show svg icon', (tester) async {
      await pumpTestApp(
        tester,
        child: AppIconButton.svgIcon(svgIcon: AppIcons.icSun, onPressed: null),
      );

      final widget = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect((widget.bytesLoader as SvgAssetLoader).assetName, AppIcons.icSun);
    });

    testWidgets('should call onPressed', (tester) async {
      int callCount = 0;

      await pumpTestApp(
        tester,
        child: AppIconButton.icon(
          icon: Icons.check,
          onPressed: () {
            callCount++;
          },
        ),
      );

      await tester.tap(find.byType(Icon));

      expect(callCount, 1);
    });

    testWidgets('should set null to onTap when onPressed is null', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        child: AppIconButton.icon(icon: Icons.check, onPressed: null),
      );

      final widget = tester.widget<InkWell>(find.byType(InkWell));

      expect(widget.onTap, isNull);
    });

    testWidgets('should show tooltip after long press', (tester) async {
      await pumpTestApp(
        tester,
        child: AppIconButton.icon(
          icon: Icons.check,
          onPressed: null,
          tooltip: 'Check button',
        ),
      );

      final widget = find.byIcon(Icons.check);

      expect(widget, findsOneWidget);

      await tester.longPress(widget);
      await tester.pump();

      expect(find.text('Check button'), findsOneWidget);
    });
  });
}
