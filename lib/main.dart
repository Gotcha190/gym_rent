import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

late StreamSubscription<bool> keyboardSubscription;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'GymRent',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            fontFamily: 'KeaniaOne',
          ),
          home: const MyHomePage(title: 'GymRent'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isKeyboardVisible = false;
  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool isVisible) {
      setState(() {
        isKeyboardVisible = isVisible;
        print(isKeyboardVisible);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // if (!isKeyboardVisible)
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h, right: 5.w, left: 5.w),
                    child: Column(
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                              fontSize: 45.sp, color: const Color(0xFFFA9F56)),
                        ),
                        Text(
                          "Login to enjoy GymRent",
                          style: TextStyle(
                              fontSize: 12.sp, color: const Color(0xFFD9DCDE)),
                        ),
                        SizedBox(height: 10.h),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: "Login",
                            filled: true,
                            fillColor: Color(0xFFD9DCDE),
                            // contentPadding: EdgeInsets.all(15.0)
                          ),
                        ),
                        SizedBox(height: 5.h),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Color(0xFFD9DCDE),
                            // contentPadding: EdgeInsets.all(15.0)
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
            ),
          ],
        ),
      ),
    );
  }
}
