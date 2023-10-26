import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgetPwd extends StatefulWidget {
  final VoidCallback navigateToLogin;
  const ForgetPwd({super.key, required this.navigateToLogin});

  @override
  State<ForgetPwd> createState() => _ForgetPwdState();
}

class _ForgetPwdState extends State<ForgetPwd> {
  /// TODO: Forget Password Page
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF848E95),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Forget Password"),
          ElevatedButton(
              onPressed: widget.navigateToLogin,
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(const Color(0xFFF77B00)),
              ),
              child: Text(
                "Go back",
                style: TextStyle(
                    fontSize: 15.sp, color: const Color(0xFFD9DCDE)),
              )),
        ],
      ),
    );
  }
}
