import 'package:flutter/material.dart';
import 'package:gym_rent/components/calendar.dart';
import 'package:gym_rent/constants/colorPalette.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:gym_rent/services/firestore/event_service.dart';

import 'events/add_event.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  Map<DateTime, List<Event>> _events = {};
  List _selectedDayEvents = [];
  late DateTime _selectedDate;
  late EventService _eventService;

  void handleDaySelected(List events, DateTime selectedDate) {
    setState(() {
      _selectedDayEvents = events;
      _selectedDate = selectedDate;
    });
  }
  Future<void> _loadFirestoreEvents() async {
    await _eventService.loadFirestoreEvents(
        _selectedDate, _events, () => setState(() {}));
  }

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
          Calendar(onDaySelectedCallback: handleDaySelected,),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDayEvents.length,
              itemBuilder: (context, index) {
                Event event = _selectedDayEvents[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.date.toString()),
                );
              },
            ),
          ),
          Text("TEST"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddEvent(
                selectedDate: _selectedDate,
              ),
            ),
          );
          if (result ?? false) {
            await _loadFirestoreEvents();
            setState(() {
              // Update any other UI-related state if needed
            });
          }
        },
        child: const Icon(Icons.add, color: ColorPalette.primary,),
        backgroundColor: ColorPalette.highlight,
      ),
    );
  }
}