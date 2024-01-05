import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_rent/constants/colorPalette.dart';
import 'package:gym_rent/services/firestore/event_service.dart';
import 'package:gym_rent/models/events_model.dart';

class Calendar extends StatefulWidget {
  final DateTime? initialDate;
  final Function(List, DateTime)? onDaySelectedCallback;
  const Calendar({Key? key, this.initialDate, this.onDaySelectedCallback})
      : super(key: key);

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
  late EventService _eventService;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _eventService = EventService();
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

  void _loadFirestoreEvents() async {
    await _eventService.loadFirestoreEvents(
        _selectedDay, _events, () => setState(() {}));
  }

  void _reloadCalendar() {
    setState(() {
      _focusedDay = DateTime.now();
      _firstDay = DateTime.now().subtract(const Duration(days: 1000));
      _lastDay = DateTime.now().add(const Duration(days: 1000));
      _selectedDay = DateTime.now();
    });
    _loadFirestoreEvents();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      eventLoader:(day) => _eventService.getEventsForTheDay(_events, day),
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: _focusedDay,
      firstDay: _firstDay,
      lastDay: _lastDay,
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        _loadFirestoreEvents();
      },
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });

        if (widget.onDaySelectedCallback != null) {
          List<Event> eventsForSelectedDay =
          _eventService.getEventsForTheDay(_events, selectedDay);
          widget.onDaySelectedCallback!(eventsForSelectedDay, _selectedDay);
        }
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
