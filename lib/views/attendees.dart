import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firestore/event_service.dart';
import 'package:gym_rent/views/authentication/profile_page.dart';

class Attendees extends StatefulWidget {
  const Attendees({super.key});

  @override
  State<Attendees> createState() => _AttendeesState();
}

class _AttendeesState extends State<Attendees> {
  bool _isLoading = true;
  late EventService _eventService;
  late List<UserModel> _users = [];

  void _loadFirestoreUsers() async {
    final coachUid = FirebaseAuth.instance.currentUser?.uid;
    if (coachUid != null) {
      setState(() {
        _isLoading = true;
      });
      _users = await _eventService.getUsersForCoach(coachUid);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _eventService = EventService();
    _loadFirestoreUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendees"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _users.isEmpty
              ? const Center(
                  child: Text("No attendees found"),
                )
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    UserModel user = _users[index];
                    return ListTile(
                      title: Text(user
                          .firstName),
                      subtitle: Text(user
                          .lastName),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              refresh: _loadFirestoreUsers,
                            ),
                            settings: RouteSettings(
                              arguments: _users[index].uid,
                            ),
                          ),
                        );
                      },
                    );
                  },
      ),
    );
  }
}
