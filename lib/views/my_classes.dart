import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:gym_rent/services/firestore/event_service.dart';
import 'package:gym_rent/views/schedule/show_event.dart';
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

  void _loadFirestoreEvents() async {
    await _eventService.getUpcomingEventsForUser(
        FirebaseAuth.instance.currentUser!.uid, _upcomingEvents, () {
      setState(() {});
    });
    await _eventService.getPastEventsForUser(
        FirebaseAuth.instance.currentUser!.uid, _pastEvents, () {
      setState(() {});
    });
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _upcomingEvents = [];
    _pastEvents = [];
    _eventService = EventService();
    _tabController = TabController(length: 2, vsync: this);
    _loadFirestoreEvents();
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
        ? const Center(
            child: Text("No events for the user."),
          )
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventItem(
                event: event,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ShowEvent(event: event);
                    },
                  );
                },
                canDelete: false,
              );
            },
          );
  }
}
