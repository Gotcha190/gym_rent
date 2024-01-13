import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firestore/user_service.dart';

class EventService {
  Future<void> loadFirestoreEvents(DateTime focusedDay,
      Map<DateTime, List<Event>> events,
      Function setStateCallback,) async {
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

  List<Event> getEventsForTheDay(Map<DateTime, List<Event>> events,
      DateTime day) {
    return events[day] ?? [];
  }

  Future<void> getUpcomingEventsForUser(String uid,
      List<Event> events,
      Function setStateCallback,) async {
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

      for (var doc in snap.docs) {
        final event = doc.data();
        events.add(event);
      }

      setStateCallback();
    } catch (e) {
      print("Error loading upcoming events for user: $e");
    }
  }

  Future<void> getUpcomingEventsForOrganizer(String uid,
      List<Event> events,
      Function setStateCallback,) async {
    try {
      final now = DateTime.now();
      final snap = await FirebaseFirestore.instance
          .collection('calendar')
          .where('organizerId', isEqualTo: uid)
          .where('date', isGreaterThanOrEqualTo: now)
          .withConverter(
        fromFirestore: Event.fromFirestore,
        toFirestore: (Event event, options) => event.toFirestore(),
      )
          .get();

      events.clear();

      for (var doc in snap.docs) {
        final event = doc.data();
        events.add(event);
      }

      setStateCallback();
    } catch (e) {
      print("Error loading events for organizer: $e");
    }
  }

  Future<void> getPastEventsForUser(String uid,
      List<Event> events,
      Function setStateCallback,) async {
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

      for (var doc in snap.docs) {
        final event = doc.data();
        events.add(event);
      }

      setStateCallback();
    } catch (e) {
      print("Error loading upcoming events for user: $e");
    }
  }

  Future<void> getPastEventsForOrganizer(String uid,
      List<Event> events,
      Function setStateCallback,) async {
    try {
      final now = DateTime.now();
      final snap = await FirebaseFirestore.instance
          .collection('calendar')
          .where('organizerId', isEqualTo: uid)
          .where('date', isLessThan: now)
          .withConverter(
        fromFirestore: Event.fromFirestore,
        toFirestore: (Event event, options) => event.toFirestore(),
      )
          .get();

      events.clear();

      for (var doc in snap.docs) {
        final event = doc.data();
        events.add(event);
      }

      setStateCallback();
    } catch (e) {
      print("Error loading upcoming events for user: $e");
    }
  }

  Future<List<UserModel>> getUsersForCoach(String coachUid) async {
    try {
      List<UserModel> users = [];
      Set<String> participantUids = {};

      // Load events for the coach within the past year
      final Map<DateTime, List<Event>> coachEvents = {};
      await loadFirestoreEvents(DateTime.now().subtract(Duration(days: 365)), coachEvents, () {});

      // Get events for the coach within the past year
      final List<Event> upcomingEvents = [];
      await getUpcomingEventsForOrganizer(coachUid, upcomingEvents, () {});

      // Iterate through each event and extract participants' UIDs
      for (var event in upcomingEvents) {
        if (event.participants != null) {
          for (var participantUid in event.participants!) {
            participantUids.add(participantUid);
          }
        }
      }

      // Load user information for each participant
      for (var participantUid in participantUids) {
        final user = await UserService.getUserById(participantUid);
        if (user != null) {
          users.add(user);
        }
      }

      return users;
    } catch (e) {
      print('Error loading users for coach: $e');
      return [];
    }
  }
}