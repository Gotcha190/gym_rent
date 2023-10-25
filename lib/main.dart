import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';
import 'package:gym_rent/WelcomePage.dart';

void main() => runApp(const MyApp());

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
            '/': (ctx) => const WelcomePage(),
          },
        );
      },
    );
  }
}
