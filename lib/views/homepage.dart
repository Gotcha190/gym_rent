import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:sizer/sizer.dart';
import 'package:gym_rent/widgets/rhombus_button.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/services/firebase_auth/firebase_auth_services.dart';

class HomePage extends StatefulWidget {

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  late String? _userRole = 'user';
  late String? _userName = 'Username';

  Future<void> _loadUser() async {
    _userRole = (await _auth.getUserRole())!;
    _userName = (await _auth.getUserName());
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  IconData _getIconForButton(int index) {
    final icons = [
      Icons.calendar_month_outlined,
      Icons.groups,
      Icons.exit_to_app,
      Icons.fitness_center,
      Icons.settings,
    ];

    return icons[index];
  }

  String _getTextForButton(int index) {
    if (_userRole == 'user' && index == 1) {
      return 'Coaches';
    }
    final texts = ['Schedule', 'Attendees', 'Logout', 'My Classes', 'Settings'];

    return texts[index];
  }

  String _getRouteForButton(int index) {
    if (_userRole == 'user' && index == 1) {
      return '/coaches';
    }
    final routes = ['/schedule', '/attendees', '/', '/my_classes', '/settings'];

    return routes[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.h,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/main_page_logo.png',
                      width: 50,
                      height: 50,
                    ),
                    Text(
                      'GymRent',
                      style: TextStyle(
                        fontSize: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: 90.h,
                  width: 100.w,
                  color: ColorPalette.secondary,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<String?>(
                          future: _auth.getUserRole(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              String role = snapshot.data ?? 'user';
                              return RichText(
                                text: TextSpan(
                                  text: 'Hello, $role ',
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontFamily: 'KeaniaOne',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: _userName,
                                      style: const TextStyle(
                                        color: ColorPalette.highlight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 2.h,
                                left: 15.w,
                                child: Column(
                                  children: List.generate(
                                    3,
                                    (index) => RhombusButton(
                                      icon: _getIconForButton(index),
                                      text: _getTextForButton(index),
                                      route: _getRouteForButton(index),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 13.h,
                                left: 45.w,
                                child: Column(
                                  children: List.generate(
                                    2,
                                    (index) => RhombusButton(
                                      icon: _getIconForButton(index + 3),
                                      text: _getTextForButton(index + 3),
                                      route: _getRouteForButton(index + 3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
