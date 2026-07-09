import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/s.dart';

class LoginValidator {
  static String? validateUsername(BuildContext context, String? text) {
    if (text == null || text.isEmpty) {
      return S.of(context).loginCorrectUsername;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? text) {
    if (text == null || text.isEmpty) {
      return S.of(context).loginCorrectPassword;
    }
    if (text.length < 8) {
      return S.of(context).loginLengthPassword(8);
    }
    return null;
  }
}
