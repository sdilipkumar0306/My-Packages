import 'package:flutter/material.dart';
import 'package:sdk0306/sdk0306.dart';

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({Key? key}) : super(key: key);

  @override
  _LoginPageUIState createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {
  TextEditingController userName = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController newUserName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: loginWidget(),
    );
  }

  Widget loginWidget() {
    return Center(
      child: Container(
        width: 600,
        height: 600,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Center(
          child: Container(
            width: 400,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.cyanAccent.shade700,
                    ),
                  ),
                ),
                CustomTextFormField(
                  textFormFieldService: TextFormFieldService(
                    textFormFields: TextFormFields(TextType.WITH_PREFIX_ICON_BG, userName),
                    borderColor: Colors.cyan,
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    iconBGColor: Colors.cyan.shade300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
