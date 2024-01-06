import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/components/event_item.dart';
import 'package:gym_rent/views/schedule/add_event.dart';
import 'package:gym_rent/views/schedule/edit_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/services/firestore/event_service.dart';
import 'package:gym_rent/models/events_model.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Event>> _events;
  late EventService _eventService;

  int _getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _eventService = EventService();
    _initializeCalendar();
    _loadFirestoreEvents();
  }

  void _initializeCalendar() {
    _events = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: _getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 100));
    _lastDay = DateTime.now().add(const Duration(days: 100));
    _selectedDay = DateTime.now();
  }

  void _loadFirestoreEvents() async {
    await _eventService.loadFirestoreEvents(
        _focusedDay, _events, () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final String receivedText =
        ModalRoute.of(context)!.settings.arguments as String;
    final String title = receivedText.substring(1).replaceFirstMapped(RegExp(r'^.'), (match) => match.group(0)!.toUpperCase());

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: ColorPalette.primary)),
        backgroundColor: ColorPalette.highlight,
      ),
      body: Container(
        color: ColorPalette.primary,
        child: Column(
          children: [
            TableCalendar(
              eventLoader: (day) =>
                  _eventService.getEventsForTheDay(_events, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  print(_focusedDay);
                });
                _loadFirestoreEvents();
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                markersMaxCount: 1,
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
                markerDecoration: BoxDecoration(
                  color: ColorPalette.secondary,
                  shape: BoxShape.circle,
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
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _eventService
                      .getEventsForTheDay(_events, _selectedDay)
                      .map(
                        (event) => EventItem(
                          event: event,
                          onTap: () async {
                            final res = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditEvent(
                                    firstDate: _firstDay,
                                    lastDate: _lastDay,
                                    event: event),
                              ),
                            );
                            if (res ?? false) {
                              _loadFirestoreEvents();
                            }
                          },
                          onDelete: () async {
                            final delete = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete Event?",
                                    style: TextStyle(
                                        color: ColorPalette.secondary)),
                                content: const Text(
                                    "Are you sure you want to delete?",
                                    style: TextStyle(
                                        color: ColorPalette.secondary)),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    style: TextButton.styleFrom(
                                      foregroundColor: ColorPalette.secondary,
                                    ),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: ColorPalette.highlight,
                                    ),
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                            if (delete ?? false) {
                              await FirebaseFirestore.instance
                                  .collection('calendar')
                                  .doc(event.id)
                                  .delete();
                              _loadFirestoreEvents();
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddEvent(
                selectedDate: _selectedDay,
              ),
            ),
          );
          if (result ?? false) {
            _loadFirestoreEvents();
          }
        },
        backgroundColor: ColorPalette.highlight,
        child: const Icon(Icons.add, color: ColorPalette.primary,),
      ),
    );
  }
}
