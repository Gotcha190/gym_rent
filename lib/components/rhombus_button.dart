import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RhombusButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final String route;

  const RhombusButton(
      {Key? key, required this.icon, required this.text, required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route, arguments: route); // TODO: Delete arguments, just there for test purposes
      },
      child: Container(
        width: 20.h,
        height: 20.h,
        margin: EdgeInsets.only(bottom: 2.5.h),
        child: CustomPaint(
          painter: RhombusPainter(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50.sp,
                color: Color(0xFFF8913A),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFFF8913A)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RhombusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white;

    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;

    final Path path = Path()
      ..moveTo(halfWidth, 0)
      ..lineTo(size.width, halfHeight)
      ..lineTo(halfWidth, size.height)
      ..lineTo(0, halfHeight)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}