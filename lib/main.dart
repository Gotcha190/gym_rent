import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/views/attendees.dart';
import 'package:gym_rent/views/my_classes.dart';
import 'package:gym_rent/views/schedule/schedule.dart';
import 'package:gym_rent/views/settings.dart';
import 'package:gym_rent/views/authentication/authentication_page.dart';
import 'package:sizer/sizer.dart';
import 'package:gym_rent/views/homepage.dart';
import 'package:gym_rent/services/firebase_options.dart';

void main() async {
  // Zainicjuj Firebase przed uruchomieniem aplikacji
  WidgetsFlutterBinding.ensureInitialized(); // To jest ważne dla Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'GymRent',
  );
  runApp(const MyApp());
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
            '/home': (ctx) => const HomePage(),
            '/schedule': (ctx) => const Schedule(),
            '/my_classes': (ctx) => const MyClasses(),
            '/attendees': (ctx) => const Attendees(),
            '/settings': (ctx) => const Settings(),
          },
        );
      },
    );
  }
}
