import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'GymRent',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'GymRent'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                 Image.asset('assets/images/main_page_logo.png',
                    width: 100.w,
                    height: 70.w),
                Text(
                  'GymRent',
                  style: TextStyle(
                    fontSize: 60.sp,
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 100.w,
                      height: 12.h,
                      child: CustomPaint(
                        painter: RoundedTrianglePainter(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey, // Kolor tła
                      ),
                    ),
                  ],
                ),
              ),
            // Tutaj możesz dodać pola do logowania i przyciski
          ],
        ),
      ),
    );
  }
}

class RoundedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo((width / 2) - 16, 10)
      ..arcToPoint(
        Offset((width / 2) + 16, 10),
        radius: const Radius.circular(40),
        clockwise: true,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
