import 'package:flutter/material.dart';
import 'ui_constants.dart';

class CommonService {
  static void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void snackbar(context, String content, {bool showLoader = true}) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(content),
            if (showLoader)
              const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void hideSnackbar(context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
