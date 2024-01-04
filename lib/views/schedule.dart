import 'package:flutter/material.dart';
import 'package:gym_rent/components/calendar.dart';
import 'package:gym_rent/constants/colorPalette.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    ///TODO: Uncomment that to after set back login page
    // final String receivedText =
    //     ModalRoute.of(context)!.settings.arguments as String;
    // final String text = receivedText.substring(1);

    return Scaffold(
      appBar: AppBar(
        ///TODO: Uncomment that to after set back login page
        // title: Text(text,style: TextStyle(color: ColorPalette.primary)),
        title: Text("CHANGE ME",style: TextStyle(color: ColorPalette.primary)),
        backgroundColor: ColorPalette.secondary,
      ),
      body: Column(
        children: [
          Calendar(),
          Text("TEST"),
        ],
      ),
    );
  }
}