import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firebase_auth/firebase_auth_services.dart';
import 'package:sizer/sizer.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback navigateToLogin;

  const SignUpPage({Key? key, required this.navigateToLogin}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _showNameFields = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
              style: TextStyle(fontSize: 45.sp, color: ColorPalette.highlight),
            ),
          ),
          Center(
            child: Text(
              "Sign Up to enjoy GymRent",
              style: TextStyle(fontSize: 12.sp, color: ColorPalette.primary),
            ),
          ),
          SizedBox(height: 5.h),
          if (!_showNameFields)
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.mail),
                filled: true,
                fillColor: ColorPalette.primary,
              ),
            ),
          if (!_showNameFields)
            SizedBox(height: 5.h),
          if (!_showNameFields)
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                filled: true,
                fillColor: ColorPalette.primary,
              ),
              obscureText: true,
            ),
          if (_showNameFields)
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: "First Name",
                filled: true,
                fillColor: ColorPalette.primary,
              ),
            ),
          if (_showNameFields)
            SizedBox(height: 5.h),
          if (_showNameFields)
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: "Last Name",
                filled: true,
                fillColor: ColorPalette.primary,
              ),
            ),
          SizedBox(height: 5.h),
          SizedBox(
            width: double.infinity,
            height: 6.5.h,
            child: ElevatedButton(
              onPressed: () => _showNameFields
                  ? _signUp()
                  : setState(() => _showNameFields = true),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ColorPalette.highlight),
              ),
              child: Text(
                _showNameFields ? "Sign Up" : "Next",
                style: TextStyle(fontSize: 15.sp, color: ColorPalette.primary),
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
                backgroundColor: MaterialStateProperty.all(ColorPalette.primary),
              ),
              child: Text(
                "Go back",
                style: TextStyle(fontSize: 15.sp, color: ColorPalette.highlight),
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
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    // Rejestracja użytkownika
    User? user = await _auth.signUpWithEmailAndPassword(email, password, UserModel(
      firstName: firstName,
      lastName: lastName,
      role: "user",
    ));

    if (user != null) {
      // Wait for the user creation process to complete
      await user.reload();
      user = await FirebaseAuth.instance.currentUser;

      // Utwórz obiekt UserProfile z pobranym uid
      UserModel userProfile = UserModel(
        uid: user!.uid,
        firstName: firstName,
        lastName: lastName,
        role: "user",
      );

      // Zaktualizuj dane w Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          userProfile.toMap()
      );

      // Przejdź do kolejnego ekranu
      Navigator.pushNamed(context, "/home");
    } else {
      print("Wszystkie pola muszą być wypełnione");
    }
  }
}
