import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:gym_rent/user_auth/firebase_auth/firebase_auth_services.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback navigateToSignup;
  final VoidCallback navigateToForgetPwd;
  LoginPage({
    super.key,
    required this.navigateToSignup,
    required this.navigateToForgetPwd,
  });
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              "Welcome",
              style: TextStyle(fontSize: 45.sp, color: const Color(0xFFFA9F56)),
            ),
          ),
          Center(
            child: Text(
              "Login to enjoy GymRent",
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFFD9DCDE)),
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
              onPressed: _signIn,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFF77B00)),
              ),
              child: Text(
                "Login",
                style:
                    TextStyle(fontSize: 15.sp, color: const Color(0xFFD9DCDE)),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              GestureDetector(
                onTap: widget.navigateToForgetPwd,
                child: Text(
                  "Forget password?",
                  style: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFFD9DCDE)),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.navigateToSignup,
                child: Text(
                  "create new account",
                  style: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFFF77B00)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      await Future.delayed(Duration.zero);
      Navigator.pushNamed(context, "/home");
    }
  }
}
