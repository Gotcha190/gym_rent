import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/user_auth/firebase_auth/firebase_auth_services.dart';
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
      color: const Color(0xFF848E95),
      child: Column(
        children: [
          Center(
            child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 45.sp, color: const Color(0xFFFA9F56)),
            ),
          ),
          Center(
            child: Text(
              "Sign Up to enjoy GymRent",
              style: TextStyle(
                  fontSize: 12.sp, color: const Color(0xFFD9DCDE)),
            ),
          ),
          SizedBox(height: 5.h),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.mail),
              filled: true,
              fillColor: Color(0xFFD9DCDE),
            ),
          ),

        SizedBox(height: 5.h),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: "Password",
            prefixIcon: Icon(Icons.lock),
            filled: true,
            fillColor: Color(0xFFD9DCDE),
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
                  const Color(0xFFF77B00)),
            ),
            child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFFD9DCDE)),
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
                  const Color(0xFFD9DCDE)),
            ),
            child: Text(
              "Go back",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFFF77B00)),
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