import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/widgets/app_dropdown_menu.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppDropdownMenu', () {
    testWidgets('should show initialSelection', (tester) async {
      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppDropdownMenu(
            initialSelection: 'Cat',
            entries: ['Cat', 'Dog'],
            labelBuilder: (text) => text,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.controller?.text, 'Cat');
    });

    testWidgets('should show all entries after tap', (tester) async {
      final entries = ['Cat', 'Dog'];

      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppDropdownMenu(entries: entries, labelBuilder: (text) => text),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      for (var entry in entries) {
        expect(
          find.widgetWithText(MenuItemButton, entry).hitTestable(),
          findsOneWidget,
        );
      }
    });

    testWidgets('should use labelBuilder', (tester) async {
      final entries = ['Cat', 'Dog'];

      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppDropdownMenu(
            entries: entries,
            labelBuilder: (text) => 'Other',
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(MenuItemButton, 'Other').hitTestable(),
        findsExactly(2),
      );
    });

    testWidgets('should call onSelected with right object', (tester) async {
      final entries = ['Cat', 'Dog'];
      String? selectedValue;

      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppDropdownMenu(
            entries: entries,
            labelBuilder: (text) => text,
            onSelected: (text) => selectedValue = text,
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      final widget = find.widgetWithText(MenuItemButton, 'Cat').hitTestable();

      expect(widget, findsOneWidget);

      await tester.tap(widget);
      await tester.pumpAndSettle();

      expect(selectedValue, 'Cat');
    });

    testWidgets('should show selected item', (tester) async {
      final entries = ['Cat', 'Dog'];

      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppDropdownMenu(entries: entries, labelBuilder: (text) => text),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      final widget = find.widgetWithText(MenuItemButton, 'Cat').hitTestable();

      expect(widget, findsOneWidget);

      await tester.tap(widget);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Cat'), findsOneWidget);
    });
  });
}
