import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/user_auth/pages/authentication_page.dart';
import 'package:sizer/sizer.dart';
import 'package:gym_rent/user_auth/pages/login_page.dart';
import 'package:gym_rent/user_auth/pages/sign_up_page.dart';
import 'package:gym_rent/user_auth/pages/forget_pwd.dart';
import 'package:gym_rent/pages/homepage.dart';
import 'firebase_options.dart';


void main() async {
  // Zainicjuj Firebase przed uruchomieniem aplikacji
  WidgetsFlutterBinding.ensureInitialized(); // To jest ważne dla Firebase

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'GymRent',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          initialRoute: '/',
          title: 'GymRent',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            fontFamily: 'KeaniaOne',
          ),
          routes: {
            '/': (ctx) => const AuthenticationScreen(),
            // '/forget_pwd': (ctx) => const ForgetPwd(),
            '/home': (ctx) => const HomePage(),
          },
        );
      },
    );
  }
}
