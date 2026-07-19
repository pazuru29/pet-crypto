import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/widgets/app_text_form_field.dart';

import '../helpers/widget_test_harness.dart';

void main() {
  group('Class AppTextFormField', () {
    testWidgets('should set written text into TextEditingController', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpTestApp(
        tester,
        child: Scaffold(body: AppTextFormField(controller: controller)),
      );

      await tester.enterText(find.byType(TextFormField), 'Marta');

      expect(find.text('Marta'), findsOneWidget);
      expect(controller.text, 'Marta');
    });

    testWidgets('should show label text', (tester) async {
      await pumpTestApp(
        tester,
        child: Scaffold(body: AppTextFormField(labelText: 'Username')),
      );

      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('should show icons', (tester) async {
      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppTextFormField(
            prefixIcon: Icon(Icons.check),
            suffixIcon: Icon(Icons.close),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should show error after failed validation', (tester) async {
      final GlobalKey<FormState> validationKey = GlobalKey<FormState>();

      await pumpTestApp(
        tester,
        child: Scaffold(
          body: Form(
            key: validationKey,
            child: AppTextFormField(
              validator: (text) {
                return 'Something went wrong';
              },
            ),
          ),
        ),
      );

      validationKey.currentState?.validate();
      await tester.pump();

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('should set obscureText to text', (tester) async {
      await pumpTestApp(
        tester,
        child: Scaffold(body: AppTextFormField(obscureText: true)),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.obscureText, isTrue);
    });

    testWidgets('should call onFieldSubmitted', (tester) async {
      String? result;

      await pumpTestApp(
        tester,
        child: Scaffold(
          body: AppTextFormField(onFieldSubmitted: (text) => result = text),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Marta');

      await tester.testTextInput.receiveAction(.done);

      expect(find.text('Marta'), findsOneWidget);
      expect(result, 'Marta');
    });
  });
}
