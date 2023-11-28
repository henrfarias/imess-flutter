import 'package:flutter/material.dart';

class KeyboardUtils {
  static bool isKeyboardShowing(BuildContext context) {
   return MediaQuery.of(context).viewInsets.bottom != 0;
  }

  static void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}