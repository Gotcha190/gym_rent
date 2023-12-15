import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:sizer/sizer.dart';

import '../components/rhombus_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
    final texts = ['Schedule', 'Attendees', 'Logout', 'My Classes', 'Settings'];

    return texts[index];
  }

  String _getRouteForButton(int index) {
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
                  color: const Color(0xFF848E95),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Hello, coach ',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontFamily: 'KeaniaOne',
                            ),
                            children: [
                              TextSpan(
                                text: 'Username', // TODO: Add user name to homepage from Firebase
                                style: TextStyle(
                                  color: Color(0xFFF8913A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 30,
                                left: 60,
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
                                top: 120,
                                left: 155,
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
