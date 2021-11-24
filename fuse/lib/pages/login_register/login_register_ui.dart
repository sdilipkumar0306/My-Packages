import 'package:flutter/material.dart';
import 'package:fuse/util/common_utils.dart';
import 'package:fuse/util/widgets.dart';

import 'login_register_modal.dart';

class LoginRegisterUI extends StatefulWidget {
  const LoginRegisterUI({Key? key}) : super(key: key);

  @override
  _LoginRegisterUIState createState() => _LoginRegisterUIState();
}

class _LoginRegisterUIState extends State<LoginRegisterUI> {
  LoginRegisterModal lrm = LoginRegisterModal();
  bool enableEmail = false;
  bool enablePassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextField(
                    controller: lrm.userNameController,
                    borderColor: Colors.cyan,
                    textFieldColor: Colors.cyan.shade900,
                    borderRadius: 5,
                    // lableText: "User Name",
                    focusBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.green)),
                    hintText: "Enter Name...",
                    textColor: Colors.white,
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    onFieldSubmitted: (data) {
                      enableEmail = true;
                      notMounted(mounted, setState);
                    },
                  ),
                  verticalSpace(10),
                  if (enableEmail)
                    MyTextField(
                      controller: lrm.emailController,
                      borderColor: Colors.cyan,
                      textFieldColor: Colors.cyan.shade900,
                      borderRadius: 5,
                      // lableText: "Email",
                      focusBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.green)),
                      hintText: "Enter Email...",
                      textColor: Colors.white,
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      onFieldSubmitted: (data) {
                        enablePassword = true;
                        notMounted(mounted, setState);
                      },
                      // errorText: "no error",
                    ),
                  verticalSpace(10),
                  if (enablePassword)
                    MyTextField(
                      controller: lrm.passwordController,
                      borderColor: Colors.cyan,
                      textFieldColor: Colors.cyan.shade900,
                      borderRadius: 5,
                      // lableText: "Password",
                      focusBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.green)),
                      hintText: "Enter Password...",
                      textColor: Colors.white,
                      prefixIcon: const Icon(Icons.security, color: Colors.white),
                      showtext: lrm.showText,
                      suffixIcon: IconButton(
                          splashRadius: 10,
                          onPressed: () {
                            lrm.showText = !lrm.showText;
                            notMounted(mounted, setState);
                          },
                          icon: Icon(
                            lrm.showText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          )),
                    ),
                  if (!enablePassword || !enableEmail)
                    MyButton(
                      child: MyText("submit"),
                      onPressed: () {
                        if (!enableEmail) {
                          enableEmail = true;
                        } else {
                          enablePassword = true;
                        }
                        notMounted(mounted, setState);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
