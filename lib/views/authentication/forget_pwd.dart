import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/colorPalette.dart';

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
      color: ColorPalette.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Forget Password"),
          ElevatedButton(
              onPressed: widget.navigateToLogin,
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(ColorPalette.highlight),
              ),
              child: Text(
                "Go back",
                style: TextStyle(
                    fontSize: 15.sp, color: ColorPalette.primary),
              )),
        ],
      ),
    );
  }
}
