import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:sizer/sizer.dart';

class WelcomePage extends StatelessWidget{
  const WelcomePage({Key? key}) : super(key: key);

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
                  color: const Color(0xFF848E95),
                  child: ListView(
                    padding: EdgeInsets.only(top: 10.h, right: 5.w, left: 5.w),
                    children: [
                      Center(
                        child: Text(
                          "Welcome",
                          style: TextStyle(
                              fontSize: 45.sp, color: const Color(0xFFFA9F56)),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Login to enjoy GymRent",
                          style: TextStyle(
                              fontSize: 12.sp, color: const Color(0xFFD9DCDE)),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Login",
                          filled: true,
                          fillColor: Color(0xFFD9DCDE),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          filled: true,
                          fillColor: Color(0xFFD9DCDE),
                        ),
                        obscureText: true, // Ukryj hasło
                      ),
                      SizedBox(height: 5.h),
                      SizedBox(
                        width: double.infinity,
                        height: 6.5.h,
                        child: ElevatedButton(
                          onPressed: () {
                            ///TODO: Login logic
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFF77B00)),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color(0xFFD9DCDE)),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ///TODO: Forget password page
                            },
                            child: Text(
                              "Forget password?",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFD9DCDE)),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              ///TODO: Creating account page
                            },
                            child: Text(
                              "create new account",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFF77B00)),
                            ),
                          ),
                        ],
                      ),
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