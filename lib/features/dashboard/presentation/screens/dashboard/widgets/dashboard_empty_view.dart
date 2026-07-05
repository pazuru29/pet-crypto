import 'package:flutter/material.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class DashboardEmptyView extends StatelessWidget {
  const DashboardEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(text: 'Here is nothing...', textStyle: .headerSemibold),
      ],
    );
  }
}
