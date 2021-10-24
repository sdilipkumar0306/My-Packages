import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_zone/services/auth_services.dart';
import 'package:our_zone/util/constants.dart';
import 'package:our_zone/util/images_display.dart';

import 'login_register.dart';

class RegisterPage extends StatefulWidget {
  final Function changePage;
  const RegisterPage({required this.changePage, Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;
  bool visableIcons = true;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  AuthService authService = AuthService();

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
                    height: size.height * 0.65,
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
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(.7),
                                ),
                              ),
                              const SizedBox(),
                              textFields(Icons.account_circle_outlined, 'User name...', false, false, username),
                              textFields(Icons.email_outlined, 'Email...', false, true, email),
                              textFields(Icons.lock_outline, 'Password...', true, false, password),
                              ElevatedButton(
                                  onPressed: () async {
                                    User result = await authService.signUpWithEmailAndPassword(email.text, password.text);

                                    print(" resulttt --- ${result.uid}");
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                                  )),
                              const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    const Text("Alredy have an Account?"),
                                    const SizedBox(),
                                    TextButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                            splashFactory: NoSplash.splashFactory,
                                            overlayColor: MaterialStateProperty.all(Colors.transparent)),
                                        onPressed: () {
                                          widget.changePage();
                                        },
                                        child: const Text(
                                          'Login',
                                          style: TextStyle(color: Colors.blueAccent),
                                        )),
                                  ],
                                ),
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
    );
  }

  Widget textFields(IconData icon, String hintText, bool isPassword, bool isEmail, TextEditingController controller) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.width / 8,
      width: size.width / 1.22,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: size.width / 30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
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
      ),
    );
  }
}
