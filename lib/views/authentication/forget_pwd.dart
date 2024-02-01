import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/color_palette.dart';

class ForgetPwd extends StatefulWidget {
  final VoidCallback navigateToLogin;
  const ForgetPwd({super.key, required this.navigateToLogin});

  @override
  State<ForgetPwd> createState() => _ForgetPwdState();
}

class _ForgetPwdState extends State<ForgetPwd> {
  final TextEditingController emailController = TextEditingController();
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content:
                const Text('An email with password reset instructions has been sent.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Password reset error: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Forget Password",
            style: TextStyle(fontSize: 35.sp, color: ColorPalette.highlight),
          ),
        ),
        Center(
          child: Text(
            "Enter your email address to reset your password",
            style: TextStyle(fontSize: 10.sp, color: ColorPalette.primary),
          ),
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Adres E-mail',
            prefixIcon: Icon(Icons.mail),
            filled: true,
            fillColor: ColorPalette.primary,
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          height: 6.5.h,
          child: ElevatedButton(
            onPressed: () {
              resetPassword(emailController.text);
            },
            child: Text('Reset password', style: TextStyle(fontSize: 15.sp, color: ColorPalette.primary)),
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          width: double.infinity,
          height: 6.5.h,
          child: ElevatedButton(
              onPressed: widget.navigateToLogin,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorPalette.primary),
              ),
              child: Text(
                "Go back",
                style: TextStyle(fontSize: 15.sp, color: ColorPalette.highlight),
              )),
        ),
      ],
    );
  }
}
