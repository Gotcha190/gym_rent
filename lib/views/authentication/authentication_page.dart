import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:gym_rent/views/authentication/sign_up_page.dart';
import 'package:sizer/sizer.dart';
import 'package:gym_rent/constants/color_palette.dart';

import 'forget_pwd.dart';
import 'login_page.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool showLoginPage = true;
  bool showForgetPwd = false;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    // Sprawdzenie, czy użytkownik jest zalogowany
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Użytkownik jest zalogowany, więc go wyloguj
      await FirebaseAuth.instance.signOut();
    }
  }

  void navigateToSignup() {
    setState(() {
      showLoginPage = false;
      showForgetPwd = false;
    });
  }

  void navigateToLogin() {
    setState(() {
      showLoginPage = true;
      showForgetPwd = false;
    });
  }

  void navigateToForgetPwd() {
    setState(() {
      showForgetPwd = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (MediaQuery.of(context).viewInsets.bottom == 0.0)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset('assets/images/main_page_logo.png',
                      width: 100.w, height: 40.w),
                  Text(
                    'GymRent',
                    style: TextStyle(
                      fontSize: 30.sp,
                    ),
                  ),
                ],
              ),
            Expanded(
              child: ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: 50.h,
                  width: 100.w,
                  color: ColorPalette.secondary,
                  child: ListView(
                    padding: EdgeInsets.only(top: 10.h, right: 5.w, left: 5.w),
                    children: [
                      showForgetPwd // Najpierw sprawdź, czy powinien być wyświetlany ekran resetowania hasła
                          ? ForgetPwd(navigateToLogin: navigateToLogin)
                          : showLoginPage // Następnie sprawdź, czy powinien być wyświetlany ekran logowania
                              ? LoginPage(
                                  navigateToSignup: navigateToSignup,
                                  navigateToForgetPwd: navigateToForgetPwd,
                                )
                              : SignUpPage(navigateToLogin: navigateToLogin),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
