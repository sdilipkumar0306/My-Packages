import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_backend/profile/profile_page.dart';
import 'package:flutter_backend/service/http_service_modal.dart';
import 'package:flutter_backend/service/https_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdk0306/sdk0306.dart';

import 'login_page_modal.dart';

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({Key? key}) : super(key: key);

  @override
  _LoginPageUIState createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> with InputValidationMixin {
  // InputValidationMixin validation = new InputValidationMixin();
  final userGlobalKey = GlobalKey<FormState>();
  final passwordGlobalKey = GlobalKey<FormState>();
  final newUserGlobalKey = GlobalKey<FormState>();
  final emailGlobalKey = GlobalKey<FormState>();
  final newPasswordGlobalKey = GlobalKey<FormState>();
  LoginpageModal loginpageModal = new LoginpageModal();
  TextEditingController userName = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController newUserName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();

  @override
  void initState() {
    userName.text = "dilipkumar";
    password.text = "1437131415";
    loginpageModal.loginMSG = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
              padding: EdgeInsets.all(20),
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text("Login",
                        style: GoogleFonts.pressStart2p(
                          color: Colors.cyanAccent.shade700,
                          fontSize: 30,
                        )),
                  ),
                  Container(
                    child: Text(
                      loginpageModal.loginMSG,
                      style: TextStyle(color: loginpageModal.loginMSGColor),
                    ),
                  ),
                  Container(
                    height: 53,
                    child: Form(
                      key: userGlobalKey,
                      child: CustomTextFormField(
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
                              return "Enter User Name";
                          },
                          iconBGColor: Colors.cyan.shade300,
                          returnBack: (data) {
                            if (data == TextType.ON_CHANGE) {
                              if (userGlobalKey.currentState!.validate()) {
                                userGlobalKey.currentState!.save();
                                // use the email provided here
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 53,
                    child: Form(
                      key: passwordGlobalKey,
                      child: CustomTextFormField(
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
                            } else if (data == TextType.ON_CHANGE) {
                              if (passwordGlobalKey.currentState!.validate()) {
                                passwordGlobalKey.currentState!.save();
                                // use the email provided here
                              }
                            }
                          },
                          validator: (data) {
                            if (isPasswordValid(password.text))
                              return null;
                            else
                              return "Enter Valid password";
                          },
                          iconBGColor: Colors.cyan.shade300,
                        ),
                      ),
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
                            returnBack: (data) async {
                              if (data == BtnConstants.ON_TAP) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Logging....."),
                                  duration: Duration(milliseconds: 30),
                                ));

                                HTTPServiceModal response = await isuserPresent();
                                setState(() {
                                  if (response.code == 200) {
                                    loginpageModal.loginMSG = "LOGIN SUCESSFULLY";
                                    loginpageModal.loginMSGColor = Colors.green;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePageUI()));
                                  } else {
                                    loginpageModal.loginMSG = "LOGIN FAILED";
                                    loginpageModal.loginMSGColor = Colors.red;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to Loging???.....")));
                                  }
                                });
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
                  Container(
                    height: 53,
                    child: Form(
                      key: newUserGlobalKey,
                      child: CustomTextFormField(
                        textFormFieldService: TextFormFieldService(
                          textFormFields: TextFormFields(TextType.WITH_PREFIX_ICON_BG, newUserName),
                          lableText: "User Name",
                          hintText: "Enter User Name",
                          borderColor: Colors.cyan,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          returnBack: (data) {
                            if (data == TextType.ON_CHANGE) {
                              if (newUserGlobalKey.currentState!.validate()) {
                                newUserGlobalKey.currentState!.save();
                                // use the email provided here
                              }
                            }
                          },
                          validator: (data) {
                            if (data != null && data.trim().length != 0)
                              return null;
                            else
                              return "Enter User Name";
                          },
                          iconBGColor: Colors.cyan.shade300,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 53,
                    child: Form(
                      child: Center(
                        key: emailGlobalKey,
                        child: CustomTextFormField(
                          textFormFieldService: TextFormFieldService(
                            textFormFields: TextFormFields(TextType.WITH_PREFIX_ICON_BG, email),
                            lableText: " Email",
                            hintText: "Enter Email",
                            borderColor: Colors.cyan,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            returnBack: (data) {
                              if (data == TextType.ON_CHANGE) {
                                if (emailGlobalKey.currentState!.validate()) {
                                  emailGlobalKey.currentState!.save();
                                  // use the email provided here
                                }
                              }
                            },
                            validator: (data) {
                              if (isEmailValid(data ?? email.text))
                                return null;
                              else
                                "Enter Vaild Email";
                            },
                            iconBGColor: Colors.cyan.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 53,
                    child: Form(
                      child: Center(
                        key: newPasswordGlobalKey,
                        child: CustomTextFormField(
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
                              if (isPasswordValid(newPassword.text))
                                return null;
                              else
                                return "Enter Valid password";
                            },
                            isPasswordVisable: loginpageModal.isRegisterPasswordVisable,
                            returnBack: (data) {
                              if (data == TextType.SUFIX_TAP) {
                                setState(() {
                                  loginpageModal.isRegisterPasswordVisable = !loginpageModal.isRegisterPasswordVisable;
                                });
                              } else if (data == TextType.ON_CHANGE) {
                                if (newPasswordGlobalKey.currentState!.validate()) {
                                  newPasswordGlobalKey.currentState!.save();
                                  // use the email provided here
                                }
                              }
                            },
                            iconBGColor: Colors.cyan.shade300,
                          ),
                        ),
                      ),
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
                            returnBack: (data) async {
                              if (data == BtnConstants.ON_TAP) {
                                await createUser();
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
                                    "Already User ?",
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
    );
  }

  Future<HTTPServiceModal> isuserPresent() async {
    var json = {"user_name": "${userName.text}", "password": "${password.text}"};
    HTTPServiceModal response = await HTTPservice.postCallWithAuth("user/IS_USER_PRESENT", json);

    if (response.code == 200) {
      UserDetails userdata = UserDetails.parseResponse(response.msg);
      LoginUserDetails.dbID = userdata.dbID;
      LoginUserDetails.name = userdata.name;
      LoginUserDetails.email = userdata.email;
      LoginUserDetails.password = userdata.password;
    } else {}

    return response;
  }

  Future<HTTPServiceModal> createUser() async {
    var json = {"user_name": "${newUserName.text}", "email": "${email.text}", "password": "${newPassword.text}"};
    HTTPServiceModal response = await HTTPservice.postCallWithAuth("user/CREATE_USER", json);

    if (response.code == 200) {
    } else {}

    return response;
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length >= 6;

  bool isEmailValid(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }
}
