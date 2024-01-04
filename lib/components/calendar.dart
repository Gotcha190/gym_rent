import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_rent/constants/colorPalette.dart';

import '../models/events_model.dart';

class Calendar extends StatefulWidget {
  final DateTime? initialDate;
  const Calendar({Key? key, this.initialDate}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Event>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = widget.initialDate ?? DateTime.now();
    _firstDay = widget.initialDate?.subtract(const Duration(days: 1000)) ??
        DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = widget.initialDate?.add(const Duration(days: 1000)) ??
        DateTime.now().add(const Duration(days: 1000));
    _selectedDay = widget.initialDate ?? DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('events')
          .withConverter(
        fromFirestore: Event.fromFirestore,
        toFirestore: (Event event, options) => event.toFirestore(),
      )
          .get();

      _events.clear();

      for (var doc in snap.docs) {
        final event = doc.data();
        final day = DateTime.utc(event.date.year, event.date.month, event.date.day);
        _events[day] = _events[day] ?? [];
        _events[day]!.add(event);
      }

      setState(() {});
    } catch (e) {
      print("Error loading Firestore events: $e");
    }
  }

  List _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      eventLoader: _getEventsForTheDay,
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: _focusedDay,
      firstDay: _firstDay,
      lastDay: _lastDay,
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        print("EVENT: ${_events[selectedDay]}");
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: const CalendarStyle(
        weekendTextStyle: TextStyle(
          color: ColorPalette.highlight,
        ),
        todayDecoration: BoxDecoration(
          color: ColorPalette.secondary,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorPalette.highlight,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(day.toString().substring(0, 10)),
          );
        },
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
      ),
    );
  }
}
