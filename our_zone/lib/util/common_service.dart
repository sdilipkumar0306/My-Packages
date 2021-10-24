import 'package:flutter/material.dart';

import 'constants.dart';

class CommonService {
  static void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => ((password.length >= 6));
  bool isuserNameValid(String username) => ((username.length >= 2));

  bool isEmailValid(String email) {
    return UiConstants.emailRegExp.hasMatch(email);
  }
}
