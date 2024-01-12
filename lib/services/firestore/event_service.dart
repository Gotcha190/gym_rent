import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_rent/models/events_model.dart';

class EventService {
  Future<void> loadFirestoreEvents(
    DateTime focusedDay,
    Map<DateTime, List<Event>> events,
    Function setStateCallback,
  ) async {
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    try {
      final snap = await FirebaseFirestore.instance
          .collection('calendar')
          .where('date', isGreaterThanOrEqualTo: firstDay)
          .where('date', isLessThanOrEqualTo: lastDay)
          .withConverter(
            fromFirestore: Event.fromFirestore,
            toFirestore: (Event event, options) => event.toFirestore(),
          )
          .get();

      events.clear();

      for (var doc in snap.docs) {
        final event = doc.data();
        final day = DateTime.utc(event.date.year, event.date.month,
            event.date.day, event.date.hour, event.date.minute);
        events[day] = events[day] ?? [];
        events[day]!.add(event);
      }

      setStateCallback();
    } catch (e) {
      print("Error loading Firestore events: $e");
    }
  }

  List<Event> getEventsForTheDay(
      Map<DateTime, List<Event>> events, DateTime day) {
    return events[day] ?? [];
  }

  Future<void> getUpcomingEventsForUser(
      String uid,
      List<Event> events,
      Function setStateCallback,
      ) async {
    try {
      final now = DateTime.now();
      final snap = await FirebaseFirestore.instance
          .collection('calendar')
          .where('participants', arrayContains: uid)
          .where('date', isGreaterThanOrEqualTo: now)
          .withConverter(
        fromFirestore: Event.fromFirestore,
        toFirestore: (Event event, options) => event.toFirestore(),
      )
          .get();

      events.clear();
      print(snap.docs);
      for (var doc in snap.docs) {
        final event = doc.data();
        events.add(event);
      }

      setStateCallback();
    } catch (e) {
      print("Error loading upcoming events for user: $e");
    }
  }

  Future<void> getPastEventsForUser(
      String uid,
      List<Event> events,
      Function setStateCallback,
      ) async {
    try {
      final now = DateTime.now();
      final snap = await FirebaseFirestore.instance
          .collection('calendar')
          .where('participants', arrayContains: uid)
          .where('date', isLessThan: now)
          .withConverter(
        fromFirestore: Event.fromFirestore,
        toFirestore: (Event event, options) => event.toFirestore(),
      )
          .get();

      events.clear();
      print(snap.docs);
      for (var doc in snap.docs) {
        final event = doc.data();
        events.add(event);
      }

      setStateCallback();
    } catch (e) {
      print("Error loading upcoming events for user: $e");
    }
  }
}
