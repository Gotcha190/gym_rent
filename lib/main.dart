import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/views/attendees.dart';
import 'package:gym_rent/views/coaches.dart';
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
    final MaterialColor customSwatch =
        createMaterialColor(ColorPalette.highlight);
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          initialRoute: '/',
          title: 'GymRent',
          theme: ThemeData(
            primarySwatch: customSwatch,
            fontFamily: 'KeaniaOne',
            appBarTheme: const AppBarTheme(
              foregroundColor: ColorPalette.primary,
            ),
          ),
          routes: {
            '/': (ctx) => const AuthenticationScreen(),
            '/home': (ctx) => HomePage(),
            '/schedule': (ctx) => const Schedule(),
            '/my_classes': (ctx) => const MyClasses(),
            '/attendees': (ctx) => const Attendees(),
            '/coaches': (ctx) => const Coaches(),
            '/settings': (ctx) => const Settings(),
          },
        );
      },
    );
  }
  MaterialColor createMaterialColor(Color color) {
    List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int strength in strengths) {
      final double ds = strength / 900.0;
      swatch[strength] = Color.fromRGBO(
        r + ((color.red - r) * ds).round(),
        g + ((color.green - g) * ds).round(),
        b + ((color.blue - b) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}