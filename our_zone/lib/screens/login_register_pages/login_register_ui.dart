// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:our_zone/screens/main_screens/home_screen/home_ui.dart';
import 'package:our_zone/util/constants/firebase_constants.dart';
import 'package:our_zone/util/modals/common_modals.dart';
import 'package:our_zone/util/modals/firebase_modals.dart';
import 'package:our_zone/util/service/auth_service.dart';
import 'package:our_zone/util/service/data_base_service.dart';
import 'package:our_zone/util/service/sharedpreference_service.dart';
import 'package:our_zone/util/static_data.dart';
import 'package:our_zone/util/widgets_ui/images_ui.dart';
import '/util/constants/service_constants.dart';
import '/util/constants/ui_constants.dart';
import 'login_register_modal.dart';

class LogInRegisterUI extends StatefulWidget {
  const LogInRegisterUI({Key? key}) : super(key: key);

  @override
  _LogInRegisterUIState createState() => _LogInRegisterUIState();
}

class _LogInRegisterUIState extends State<LogInRegisterUI> with InputValidationMixin {
  LoginGegister lg = LoginGegister();

  void valueChanging() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      lg.primaryContainerposition = -(lg.size.height * 0.45) - 1;
      lg.mainContainerBorderRadius = 40;
      lg.imageContainerSize = lg.containerSize * 1.2;
      lg.imageContainerLeftPosition = lg.size.width * 0.1;
      lg.imagecontainerBottomPosition = 10;
      lg.textContainerLeftPosition = (lg.size.width * 0.1 + (lg.containerSize * 1.2) + 20);
      lg.textcontainerBottomPosition = 12;
      lg.contentContainerHeight = lg.size.height * 0.75;
    } else {
      if (lg.isPageChanged) {
        lg.primaryContainerposition = -(lg.size.height * 0.5) - 1;
        lg.mainContainerBorderRadius = 40;
        lg.imageContainerSize = lg.containerSize * 1.2;
        lg.imageContainerLeftPosition = lg.size.width * 0.1;
        lg.imagecontainerBottomPosition = 30;
        lg.textContainerLeftPosition = (lg.size.width * 0.1 + (lg.containerSize * 1.2) + 20);
        lg.textcontainerBottomPosition = 35;
        lg.contentContainerHeight = lg.size.height * 0.8;
      } else {
        lg.primaryContainerposition = -(lg.size.height * (0.4)) - 1;
        lg.mainContainerBorderRadius = 60;
        lg.imageContainerSize = lg.containerSize * 2;
        lg.imageContainerLeftPosition = (lg.size.width / 2) - lg.containerSize;
        lg.imagecontainerBottomPosition = 70;
        lg.textContainerLeftPosition = (lg.size.width / 2) - 75;
        lg.textcontainerBottomPosition = 15;
        lg.contentContainerHeight = lg.size.height * 0.7;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    lg.size = MediaQuery.of(context).size;
    valueChanging();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            onTap: () {
              CommonService.closeKeyboard(context);
            },
            child: poterateScreen()));
  }

  Widget poterateScreen() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
        UiConstants.myColor,
        UiConstants.myColor,
        UiConstants.myColor,
        UiConstants.myColor,
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,
        // Color(0*003049)
      ])),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: lg.dur,
            top: lg.primaryContainerposition,
            child: AnimatedContainer(
              duration: lg.dur,
              height: lg.size.height * 0.7,
              width: lg.size.width,
              decoration:
                  BoxDecoration(color: UiConstants.myColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(lg.mainContainerBorderRadius))),
              child: Stack(
                children: [
                  AnimatedPositioned(
                      bottom: lg.imagecontainerBottomPosition,
                      left: lg.imageContainerLeftPosition,
                      child: AnimatedContainer(
                        width: lg.imageContainerSize,
                        height: lg.imageContainerSize,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        duration: lg.dur,
                        child: const Card(
                          child: ImagesOZ(
                            image: UiConstants.logopath,
                            borderRadius: BorderRadius.all(Radius.circular(500)),
                            width: 100,
                            height: 100,
                          ),
                          elevation: 15,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100.0))),
                        ),
                      ),
                      duration: lg.dur),
                  AnimatedPositioned(
                      bottom: lg.textcontainerBottomPosition,
                      left: lg.textContainerLeftPosition,
                      child: Container(
                        width: 150,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          UiConstants.appName,
                          style: GoogleFonts.cevicheOne(
                            color: Colors.white,
                            fontSize: 35,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      duration: lg.dur),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: lg.dur,
              height: lg.contentContainerHeight,
              width: lg.size.width,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(lg.mainContainerBorderRadius))),
              child: Container(
                child: loginUi(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginUi() {
    final double bottom = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      // reverse: true,
      // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: AnimatedCrossFade(
                              firstChild: Text(
                                "Sign In",
                                style: GoogleFonts.fruktur(
                                  color: UiConstants.myColor,
                                  fontSize: 35,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              secondChild: Text(
                                "Sign Up",
                                style: GoogleFonts.fruktur(
                                  color: UiConstants.myColor,
                                  fontSize: 35,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              crossFadeState: lg.isPageChanged ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: lg.dur)),
                    ],
                  ),
                  AnimatedOpacity(
                    opacity: lg.isPageChanged ? 1 : 0,
                    duration: lg.dur,
                    child: AnimatedContainer(
                      duration: lg.dur,
                      height: lg.isPageChanged ? 80 : 0,
                      width: lg.size.width > 400 ? 400 : lg.size.width,
                      decoration: BoxDecoration(
                          color: lg.isenable ? Colors.transparent : UiConstants.myColor, borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: lg.isenable
                          ? textFields(
                              icon: Icons.account_circle_outlined,
                              hintText: "User name...",
                              isPassword: false,
                              isEmail: false,
                              controller: lg.nameController,
                              validator: lg.userNameError,
                              onchange: () {
                                if (lg.isbuttonClicked) {
                                  setState(() {
                                    lg.userNameError = (isuserNameValid(lg.nameController.text)) ? null : "Enter User Name";
                                  });
                                }
                              })
                          : null,
                    ),
                  ),
                  if (lg.isPageChanged) const SizedBox(height: 20),
                  SizedBox(
                    height: 80,
                    child: textFields(
                        icon: Icons.email_outlined,
                        hintText: "Email..",
                        isPassword: false,
                        isEmail: true,
                        controller: lg.emailController,
                        validator: lg.emmailError,
                        onchange: () {
                          if (lg.isbuttonClicked) {
                            setState(() {
                              lg.emmailError = (isEmailValid(lg.emailController.text)) ? null : "Enter valid Email";
                            });
                          }
                        }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 80,
                    child: textFields(
                        icon: Icons.lock_outline,
                        hintText: "Password..",
                        isPassword: true,
                        isEmail: false,
                        controller: lg.passwordController,
                        validator: lg.passwoedError,
                        onchange: () {
                          if (lg.isbuttonClicked) {
                            setState(() {
                              lg.passwoedError = (isPasswordValid(lg.passwordController.text)) ? null : "Enter valid Password";
                            });
                          }
                        }),
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: lg.isPageChanged ? 0 : 1,
                    duration: lg.dur,
                    child: AnimatedContainer(
                      height: lg.isPageChanged ? 0 : 40,
                      duration: lg.dur,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot password!",
                                style: GoogleFonts.oldStandardTt(
                                  color: UiConstants.myColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedCrossFade(
                            firstChild: Container(
                              width: 200,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(UiConstants.myColor),
                                    backgroundColor: MaterialStateProperty.all(UiConstants.myColor)),
                                onPressed: lg.enableButton
                                    ? () {
                                        logincall();
                                      }
                                    : null,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      "Sign in",
                                      style: GoogleFonts.domine(
                                        color: Colors.white,
                                        fontSize: 20,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            secondChild: Container(
                              width: 200,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(UiConstants.myColor),
                                    backgroundColor: MaterialStateProperty.all(UiConstants.myColor)),
                                onPressed: lg.enableButton
                                    ? () {
                                        // signupCall();
                                      }
                                    : null,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.domine(
                                        color: Colors.white,
                                        fontSize: 20,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            crossFadeState: lg.isPageChanged ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            duration: lg.dur)
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedCrossFade(
                              firstChild: Text(
                                "New to ${UiConstants.appName}? ",
                                style: GoogleFonts.cormorantGaramond(color: UiConstants.myColor, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              secondChild: Text(
                                "Alredy have an Account. ",
                                style: GoogleFonts.cormorantGaramond(color: UiConstants.myColor, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              crossFadeState: lg.isPageChanged ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: lg.dur),
                          TextButton(
                              onPressed: () {
                                lg.isPageChanged = !lg.isPageChanged;

                                lg.emailController.clear();
                                lg.nameController.clear();
                                lg.passwordController.clear();
                                if (!mounted) return;
                                setState(() {});

                                valueChanging();

                                if (!lg.isPageChanged) lg.isenable = false;
                                if (!mounted) return;
                                setState(() {});
                                if (lg.isPageChanged) {
                                  Timer(lg.dur, () {
                                    lg.isenable = true;
                                    if (!mounted) return;
                                    setState(() {});
                                  });
                                }
                              },
                              child: AnimatedCrossFade(
                                  firstChild: Text(
                                    "Sign up now",
                                    style: GoogleFonts.cormorantGaramond(
                                        // color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  secondChild: Text(
                                    "Sign in",
                                    style: GoogleFonts.cormorantGaramond(
                                        // color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  crossFadeState: lg.isPageChanged ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: lg.dur)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFields(
      {required IconData icon,
      required String hintText,
      required bool isPassword,
      required bool isEmail,
      required TextEditingController controller,
      required String? validator,
      required Function onchange}) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      Size lcSize = Size(constraints.maxWidth, constraints.maxHeight);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: (lcSize.height == 80) ? lcSize.height - 20 : null,
            width: lcSize.width > 400 ? 400 : lcSize.width,
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: size.width / 30),
            decoration: BoxDecoration(
              color: UiConstants.myColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              // validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              style: const TextStyle(color: Colors.white),
              obscureText: (isPassword) ? lg.visableIcons : isPassword,
              keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  color: Colors.white,
                ),
                border: InputBorder.none,
                suffixIcon: isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            lg.visableIcons = !lg.visableIcons;
                          });
                        },
                        icon: Icon(
                          lg.visableIcons ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ))
                    : null,
                hintMaxLines: 1,
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              onChanged: (data) {
                onchange();
              },
            ),
          ),
          Container(
            height: (lcSize.height == 80) ? null : 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: Text(
              (validator == null) ? "" : validator,
              style: const TextStyle(color: Colors.red),
            ),
          )
        ],
      );
    });
  }

  Future<void> signupCall() async {
    AuthService authService = AuthService();
    CommonService.closeKeyboard(context);
    setState(() {
      lg.isbuttonClicked = true;
      lg.userNameError = (isuserNameValid(lg.nameController.text)) ? null : "Enter User Name";
      lg.emmailError = (isEmailValid(lg.emailController.text)) ? null : "Enter valid Email";
      lg.passwoedError = (isPasswordValid(lg.passwordController.text)) ? null : "Enter valid Password";
    });
    if (isEmailValid(lg.emailController.text) && isPasswordValid(lg.passwordController.text) && isuserNameValid(lg.nameController.text)) {
      setState(() {
        lg.enableButton = false;
      });
      FBUser newUser = FBUser(userID: "NA", name: lg.nameController.text, email: lg.emailController.text);
      CommonService.snackbar(context, "Loading Please wait....");
      OurZoneResponse? response = await authService.signUpWithEmailAndPassword(newUser.email, lg.passwordController.text);
      if (response.code == 200) {
        String uid = response.response;
        newUser.userID = uid;
        String? returResponse = DatabaseMethods().createUserInFirebase(newUser);

        SPS.setvalue(UserConst.userID, uid);
        SPS.setvalue(UserConst.userEmail, newUser.email);
        UserData.primaryUser = FBUser(userID: uid, name: newUser.email, email: newUser.name, profileImage: newUser.profileImage, aboutUser: newUser.aboutUser);
        CommonService.hideSnackbar(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreenUI()));
      } else {
        CommonService.hideSnackbar(context);
        setState(() {
          lg.enableButton = true;
          lg.passwoedError = "Email already taken..";
        });
      }
    }
  }

  Future<void> logincall() async {
    CommonService.closeKeyboard(context);
    AuthService authService = AuthService();
    setState(() {
      lg.isbuttonClicked = true;
      lg.emmailError = (isEmailValid(lg.emailController.text)) ? null : "Enter valid Email";
      lg.passwoedError = (isPasswordValid(lg.passwordController.text)) ? null : "Enter valid Password";
    });
    if (isEmailValid(lg.emailController.text) && isPasswordValid(lg.passwordController.text)) {
      setState(() {
        lg.enableButton = false;
      });
      CommonService.snackbar(context, "Loading Please wait....");

      OurZoneResponse? response = await authService.signInWithEmailAndPassword(lg.emailController.text, lg.passwordController.text);
      if (response.code == 200) {
        SPS.setvalue(UserConst.userID, response.response);
        SPS.setvalue(UserConst.userEmail, lg.emailController.text);
        FBUser? user = await DatabaseMethods().getUserDetails(response.response);
        if (user != null) {
          UserData.primaryUser = user;
          CommonService.hideSnackbar(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreenUI()));
        }
      } else {
        CommonService.hideSnackbar(context);
        setState(() {
          lg.passwoedError = "Enter valid Email/Password";
          lg.enableButton = true;
        });
      }
    }
  }
}
