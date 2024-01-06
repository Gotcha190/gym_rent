import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/services/firebase_auth/firebase_auth_services.dart';
import 'package:sizer/sizer.dart';

class SignUpPage extends StatefulWidget{
  final VoidCallback navigateToLogin;

  const SignUpPage({Key? key, required this.navigateToLogin}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorPalette.secondary,
      child: Column(
        children: [
          Center(
            child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 45.sp, color: ColorPalette.highlight),
            ),
          ),
          Center(
            child: Text(
              "Sign Up to enjoy GymRent",
              style: TextStyle(
                  fontSize: 12.sp, color: ColorPalette.primary),
            ),
          ),
          SizedBox(height: 5.h),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.mail),
              filled: true,
              fillColor: ColorPalette.primary,
            ),
          ),

        SizedBox(height: 5.h),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: "Password",
            prefixIcon: Icon(Icons.lock),
            filled: true,
            fillColor: ColorPalette.primary,
          ),
          obscureText: true, // Hide password
        ),
        SizedBox(height: 5.h),
        SizedBox(
          width: double.infinity,
          height: 6.5.h,
          child: ElevatedButton(
            onPressed: _signUp,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  ColorPalette.highlight),
            ),
            child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: ColorPalette.primary),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          width: double.infinity,
          height: 6.5.h,
          child: ElevatedButton(
            onPressed: widget.navigateToLogin,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  ColorPalette.primary),
            ),
            child: Text(
              "Go back",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: ColorPalette.highlight),
            ),
          ),
        ),
        ],
      ),
    );
  }

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null){
      await Future.delayed(Duration.zero);
      Navigator.pushNamed(context, "/home");
    }
  }
}