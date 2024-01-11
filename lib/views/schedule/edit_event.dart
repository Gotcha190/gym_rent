import 'package:flutter/material.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firestore/user_service.dart';
import 'package:gym_rent/views/forms/edit_event_form.dart';

class EditEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Event event;

  const EditEvent({
    Key? key,
    required this.firstDate,
    required this.lastDate,
    required this.event,
  }) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late List<UserModel> _coachUsers;
  late List<UserModel> _users;
  late UserModel? _selectedOrganizer;
  late List<UserModel> _selectedParticipants = [];
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUsers();
    await _loadCoachUsers();
    await _loadSelectedOrganizer();
    await _loadSelectedParticipants();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : EditEventForm(
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              titleController: TextEditingController(text: widget.event.title),
              descController:
                  TextEditingController(text: widget.event.description),
              event: widget.event,
              users: _users,
              coachUsers: _coachUsers,
              selectedOrganizer: _selectedOrganizer,
              selectedParticipants: _selectedParticipants,
            ),
    );
  }

  Future<void> _loadUsers() async {
    _users = await UserService.getUsers();
    setState(() {});
  }

  Future<void> _loadCoachUsers() async {
    _coachUsers = await UserService.getCoachUsers();
    setState(() {});
  }

  Future<void> _loadSelectedOrganizer() async {
    if (widget.event.organizerId != null) {
      UserModel? organizer =
          await UserService.getUserById(widget.event.organizerId!);
      setState(() {
        _selectedOrganizer = organizer;
      });
    }
  }

  Future<void> _loadSelectedParticipants() async {
    if (widget.event.participants != null) {
      List<UserModel?> participants = await Future.wait<UserModel?>(
        widget.event.participants!
            .map((participantId) => UserService.getUserById(participantId)),
      );

      setState(() {
        _selectedParticipants = participants.whereType<UserModel>().toList();
      });
    }
  }
}
