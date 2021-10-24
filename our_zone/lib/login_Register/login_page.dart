// ignore_for_file: avoid_print
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_zone/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/util/services/auth_services.dart';
import 'package:our_zone/util/common_service.dart';
import 'package:our_zone/util/constants.dart';
import 'package:our_zone/util/images_display.dart';

class LoginPage extends StatefulWidget {
  final Function changePage;
  const LoginPage({required this.changePage, Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin, InputValidationMixin {
  AuthService authservice = AuthService();
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;
  bool visableIcons = true;
  bool isloginClicked = false;
  String? emmailError;
  String? passwoedError;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final emailformKey = GlobalKey<FormState>();
  final passwordformKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: GestureDetector(
              onTap: () {
                CommonService.closeKeyboard(context);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade600,
                      Colors.cyan,
                    ],
                  ),
                ),
                child: Opacity(
                  opacity: _opacity.value,
                  child: Transform.scale(
                    scale: _transform.value,
                    child: Container(
                      width: size.width * .9,
                      height: size.height * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            blurRadius: 90,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  blurRadius: 90,
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.only(top: 50),
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            height: size.height * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(.7),
                                  ),
                                ),
                                const SizedBox(),
                                textFields(
                                    icon: Icons.email_outlined,
                                    hintText: "Email..",
                                    isPassword: false,
                                    isEmail: true,
                                    controller: email,
                                    validator: emmailError,
                                    onchange: () {
                                      if (isloginClicked) {
                                        setState(() {
                                          emmailError = (isEmailValid(email.text)) ? null : "Enter valid Email";
                                        });
                                      }
                                    }),
                                const SizedBox(),
                                textFields(
                                    icon: Icons.lock_outline,
                                    hintText: "Password..",
                                    isPassword: true,
                                    isEmail: false,
                                    controller: password,
                                    validator: passwoedError,
                                    onchange: () {
                                      if (isloginClicked) {
                                        setState(() {
                                          passwoedError = (isPasswordValid(password.text)) ? null : "Enter valid Password";
                                        });
                                      }
                                    }),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          CommonService.closeKeyboard(context);
                                          setState(() {
                                            isloginClicked = true;
                                            emmailError = (isEmailValid(email.text)) ? null : "Enter valid Email";
                                            passwoedError = (isPasswordValid(password.text)) ? null : "Enter valid Password";
                                          });
                                          if (isEmailValid(email.text) && isPasswordValid(password.text)) {
                                            print("login");
                                            User? result = await authservice.signInWithEmailAndPassword(email.text, password.text);

                                            if (result != null) {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setString("user_login_id", result.uid);
                                              String? uid = result.uid;
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyCustomUI(uid)));
                                            } else {
                                              setState(() {
                                                passwoedError = "Enter valid Email/Password";
                                              });
                                            }
                                            print(" resulttt --- ${result == null}");
                                            print(" resulttt --- ${result?.uid}");
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Text("Login", style: TextStyle(color: Colors.white)),
                                        )),
                                    SizedBox(width: size.width / 25),
                                    Container(
                                      width: size.width / 2.6,
                                      alignment: Alignment.center,
                                      child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                              splashFactory: NoSplash.splashFactory,
                                              overlayColor: MaterialStateProperty.all(Colors.transparent)),
                                          onPressed: () {},
                                          child: const Text(
                                            'Forgotten password!',
                                            style: TextStyle(color: Colors.blueAccent),
                                          )),
                                    )
                                  ],
                                ),
                                const SizedBox(),
                                TextButton(
                                  onPressed: () {
                                    widget.changePage();
                                  },
                                  child: const Text(
                                    'Create a new Account',
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                      splashFactory: NoSplash.splashFactory,
                                      overlayColor: MaterialStateProperty.all(Colors.transparent)),
                                ),
                                const SizedBox(),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 2000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: const Card(
                                child: AssetCircularImage(height: 100, width: 100, imagePath: UiConstants.logopath),
                                elevation: 15,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100.0))),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: size.width / 8,
          width: size.width / 1.22,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: size.width / 30),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            // validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            style: TextStyle(color: Colors.black.withOpacity(.8)),
            obscureText: (isPassword) ? visableIcons : isPassword,
            keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.black.withOpacity(.7),
              ),
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          visableIcons = !visableIcons;
                        });
                      },
                      icon: Icon(
                        visableIcons ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ))
                  : null,
              hintMaxLines: 1,
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
            ),
            onChanged: (data) {
              onchange();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Text(
            (validator == null) ? "" : validator,
            style: const TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}
