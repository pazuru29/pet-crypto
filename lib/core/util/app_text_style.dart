import 'package:flutter/widgets.dart';

enum AppTextStyle {
  // Regular
  hintRegular(TextStyle(fontSize: 12, fontWeight: .normal)),
  bodyRegular(TextStyle(fontSize: 16, fontWeight: .normal)),
  headerRegular(TextStyle(fontSize: 18, fontWeight: .normal)),
  titleRegular(TextStyle(fontSize: 20, fontWeight: .normal)),

  // Semibold
  hintSemibold(TextStyle(fontSize: 12, fontWeight: .w600)),
  bodySemibold(TextStyle(fontSize: 16, fontWeight: .w600)),
  headerSemibold(TextStyle(fontSize: 18, fontWeight: .w600)),
  titleSemibold(TextStyle(fontSize: 20, fontWeight: .w600)),

  // Bold
  hintBold(TextStyle(fontSize: 12, fontWeight: .bold)),
  bodyBold(TextStyle(fontSize: 16, fontWeight: .bold)),
  headerBold(TextStyle(fontSize: 18, fontWeight: .bold)),
  titleBold(TextStyle(fontSize: 20, fontWeight: .bold));

  final TextStyle style;

  const AppTextStyle(this.style);
}
