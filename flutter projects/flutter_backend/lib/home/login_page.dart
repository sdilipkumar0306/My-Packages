import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdk0306/sdk0306.dart';

import 'login_page_modal.dart';

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({Key? key}) : super(key: key);

  @override
  _LoginPageUIState createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {
  final formGlobalKey = GlobalKey<FormState>();
  LoginpageModal loginpageModal = new LoginpageModal();
  TextEditingController userName = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController newUserName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: loginpageModal.isLoginPage ? loginWidget() : registerWidget(),
    );
  }

  Widget loginWidget() {
    return Center(
      child: Container(
        width: 500,
        height: 600,
        child: Card(
          shadowColor: Colors.cyan,
          color: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Container(
              width: 400,
              child: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text("Login",
                          style: GoogleFonts.pressStart2p(
                            color: Colors.cyanAccent.shade700,
                            fontSize: 30,
                          )),
                    ),
                    CustomTextFormField(
                      textFormFieldService: TextFormFieldService(
                        textFormFields: TextFormFields(TextType.WITH_PREFIX_ICON_BG, userName),
                        lableText: "User Name",
                        hintText: "Enter User Name",
                        borderColor: Colors.cyan,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        validator: (data) {
                          if (data != null && data.trim().length != 0)
                            return null;
                          else
                            return "Enter Data";
                        },
                        iconBGColor: Colors.cyan.shade300,
                        returnBack: (data) {},
                      ),
                    ),
                    CustomTextFormField(
                      textFormFieldService: TextFormFieldService(
                        textFormFields: TextFormFields(TextType.WITH_BOTH_ICONS_BG, password),
                        lableText: "Password",
                        hintText: "Enter Password",
                        borderColor: Colors.cyan,
                        prefixIcon: Icon(
                          Icons.security,
                          color: Colors.white,
                        ),
                        sufixIcon: Icon(
                          ((loginpageModal.isloginPasswordVisable) ? Icons.visibility : Icons.visibility_off),
                          color: Colors.white,
                        ),
                        isPasswordVisable: loginpageModal.isloginPasswordVisable,
                        returnBack: (data) {
                          if (data == TextType.SUFIX_TAP) {
                            setState(() {
                              loginpageModal.isloginPasswordVisable = !loginpageModal.isloginPasswordVisable;
                            });
                          }
                        },
                        validator: (data) {
                          if (data != null && data.trim().length != 0)
                            return null;
                          else
                            return "error";
                        },
                        iconBGColor: Colors.cyan.shade300,
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 40,
                      child: Buttons(
                        ButtonService(
                            buttonData: ButtonData(
                              text: "Login",
                              type: BtnConstants.WITHOUT_ICON,
                              returnBack: (data) {
                                if (data == BtnConstants.ON_TAP) {
                                  print("login......");
                                  if (formGlobalKey.currentState!.validate()) {
                                    formGlobalKey.currentState!.save();
                                    // use the email provided here
                                  }
                                }
                              },
                            ),
                            bGColor: Colors.cyan,
                            textColor: Colors.white,
                            txtSize: 18,
                            borderColor: Colors.cyan),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        loginpageModal.isLoginPage = false;
                                      });
                                    },
                                    child: Text(
                                      "New User ?",
                                      style: GoogleFonts.lusitana(color: Colors.cyan, fontSize: 18),
                                    ))),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Forget Password.",
                                      style: GoogleFonts.lusitana(color: Colors.cyan, fontSize: 18),
                                    ))),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Center(
      child: Container(
        width: 500,
        height: 600,
        child: Card(
          shadowColor: Colors.cyan,
          color: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Container(
              width: 400,
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text("Register",
                          style: GoogleFonts.pressStart2p(
                            color: Colors.cyanAccent.shade700,
                            fontSize: 30,
                          )),
                    ),
                    CustomTextFormField(
                      textFormFieldService: TextFormFieldService(
                        textFormFields: TextFormFields(TextType.WITH_PREFIX_ICON_BG, newUserName),
                        lableText: "User Name",
                        hintText: "Enter User Name",
                        borderColor: Colors.cyan,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        returnBack: (data) {},
                        validator: (data) {
                          if (data != null && data.trim().length != 0) {
                            return "error";
                          }
                        },
                        iconBGColor: Colors.cyan.shade300,
                      ),
                    ),
                    CustomTextFormField(
                      textFormFieldService: TextFormFieldService(
                        textFormFields: TextFormFields(TextType.WITH_PREFIX_ICON_BG, email),
                        lableText: " Email",
                        hintText: "Enter Email",
                        borderColor: Colors.cyan,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        returnBack: (data) {},
                        validator: (data) {
                          if (data != null && data.trim().length != 0) {
                            return "error";
                          }
                        },
                        iconBGColor: Colors.cyan.shade300,
                      ),
                    ),
                    CustomTextFormField(
                      textFormFieldService: TextFormFieldService(
                        textFormFields: TextFormFields(TextType.WITH_BOTH_ICONS_BG, newPassword),
                        lableText: "Password",
                        hintText: "Enter Password",
                        borderColor: Colors.cyan,
                        prefixIcon: Icon(
                          Icons.security,
                          color: Colors.white,
                        ),
                        sufixIcon: Icon(
                          ((loginpageModal.isRegisterPasswordVisable) ? Icons.visibility : Icons.visibility_off),
                          color: Colors.white,
                        ),
                        validator: (data) {
                          if (data != null && data.trim().length != 0) {
                            return "error";
                          }
                        },
                        isPasswordVisable: loginpageModal.isRegisterPasswordVisable,
                        returnBack: (data) {
                          if (data == TextType.SUFIX_TAP) {
                            setState(() {
                              loginpageModal.isRegisterPasswordVisable = !loginpageModal.isRegisterPasswordVisable;
                            });
                          }
                        },
                        iconBGColor: Colors.cyan.shade300,
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 40,
                      child: Buttons(
                        ButtonService(
                            buttonData: ButtonData(
                              text: "Register",
                              type: BtnConstants.WITHOUT_ICON,
                              returnBack: (data) {
                                if (data == BtnConstants.ON_TAP) {
                                  print("Register......");
                                }
                              },
                            ),
                            bGColor: Colors.cyan,
                            textColor: Colors.white,
                            txtSize: 18,
                            borderColor: Colors.cyan),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        loginpageModal.isLoginPage = true;
                                      });
                                    },
                                    child: Text(
                                      "Alredy User ?",
                                      style: GoogleFonts.lusitana(color: Colors.cyan, fontSize: 18),
                                    ))),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
