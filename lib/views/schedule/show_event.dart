import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:sizer/sizer.dart';

class ShowEvent extends StatefulWidget {
  final Event event;

  const ShowEvent({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<ShowEvent> createState() => _ShowEventState();
}

class _ShowEventState extends State<ShowEvent> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.event.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Event"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Text(
                    _selectedDateTime.toString().substring(0, 16),
                    style: const TextStyle(
                      color: ColorPalette.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.event.title,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.highlight,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Event Description:",
                      style: TextStyle(
                          fontSize: 10.sp, color: ColorPalette.secondary),
                    ),
                    Text(
                      widget.event.description ?? 'No Description',
                      style: TextStyle(
                          fontSize: 16.sp, color: ColorPalette.secondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop<bool>(context, true);
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 0)),
            child: const Text("Close",
                style: TextStyle(fontSize: 18, color: ColorPalette.primary)),
          ),
        ],
      ),
    );
  }
}
