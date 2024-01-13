import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:gym_rent/services/firebase_auth/firebase_auth_services.dart';
import 'package:gym_rent/services/firestore/event_service.dart';
import 'package:gym_rent/views/schedule/edit_event.dart';
import 'package:gym_rent/views/schedule/show_event.dart';
import 'package:gym_rent/widgets/delete_dialog.dart';
import 'package:gym_rent/widgets/event_item.dart';
import 'package:sizer/sizer.dart';

class MyClasses extends StatefulWidget {
  const MyClasses({super.key});

  @override
  State<MyClasses> createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses>
    with SingleTickerProviderStateMixin {
  late EventService _eventService;
  late List<Event> _upcomingEvents;
  late List<Event> _pastEvents;
  late bool _isLoading = true;
  late TabController _tabController;
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  late String? _userRole = 'user';

  Future<void> _loadUserRole() async {
    _userRole = (await _auth.getUserRole())!;
    if (mounted) {
      setState(() {});
    }
  }

  void _loadFirestoreEvents() async {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    print(userUid);
    print(_userRole);
    if (_userRole == 'user') {
      await _eventService.getUpcomingEventsForUser(userUid!, _upcomingEvents,
          () {
        setState(() {});
      });
      await _eventService.getPastEventsForUser(userUid!, _pastEvents, () {
        setState(() {});
      });
    } else {
      await _eventService
          .getUpcomingEventsForOrganizer(userUid!, _upcomingEvents, () {
        setState(() {});
      });
      await _eventService.getPastEventsForOrganizer(userUid!, _pastEvents, () {
        setState(() {});
      });
    }

    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _upcomingEvents = [];
    _pastEvents = [];
    _eventService = EventService();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserRole().then((_) {
      _loadFirestoreEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Classes"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
          labelColor: ColorPalette.primary,
        ),
      ),
      body: _isLoading
          ? SizedBox(
              height: 40.h,
              child: const Center(child: CircularProgressIndicator()),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildEventsList(_upcomingEvents),
                _buildEventsList(_pastEvents),
              ],
            ),
    );
  }

  Widget _buildEventsList(List<Event> events) {
    return events.isEmpty
        ? const Column(
            children: [
              Text("Nothing to show there",
                  style: TextStyle(color: ColorPalette.secondary)),
              Text('Participate in event to be able to see them there',
                  style: TextStyle(color: ColorPalette.secondary)),
            ],
          )
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventItem(
                event: event,
                onTap: () async {
                  if (_userRole == 'user') {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowEvent(event: event);
                      },
                    );
                  } else {
                    final res = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditEvent(
                            firstDate:
                                event.date.subtract(const Duration(days: 100)),
                            lastDate:
                                event.date.subtract(const Duration(days: 100)),
                            event: event),
                      ),
                    );
                    if (res ?? false) {
                      _loadFirestoreEvents();
                    }
                  }
                },
                onDelete: () async {
                  bool? result = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteDialog(event: event);
                    },
                  );
                  if (result ?? false) {
                    await FirebaseFirestore.instance
                        .collection('calendar')
                        .doc(event.id)
                        .delete();
                    _loadFirestoreEvents();
                  }
                },
                canDelete: _userRole != 'user',
              );
            },
          );
  }
}
