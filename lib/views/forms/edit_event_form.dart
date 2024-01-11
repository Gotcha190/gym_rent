import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/widgets/date_picker_widget.dart';
import 'package:gym_rent/widgets/organizer_picker_widget.dart';
import 'package:gym_rent/widgets/participants_picker_widget.dart';

class EditEventForm extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final TextEditingController titleController;
  final TextEditingController descController;
  final Event event;
  final List<UserModel> users;
  final List<UserModel> coachUsers;
  final UserModel? selectedOrganizer;
  final List<UserModel> selectedParticipants;

  EditEventForm({
    Key? key,
    required this.firstDate,
    required this.lastDate,
    required this.titleController,
    required this.descController,
    required this.event,
    required this.users,
    required this.coachUsers,
    required this.selectedOrganizer,
    required this.selectedParticipants,
  }) : super(key: key);

  @override
  _EditEventFormState createState() => _EditEventFormState();
}

class _EditEventFormState extends State<EditEventForm> {
  late DateTime _firstDate;
  late DateTime _lastDate;
  late DateTime _selectedDateTime;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late List<UserModel> _coachUsers;
  late List<UserModel> _users;
  late UserModel? _selectedOrganizer;
  late List<UserModel> _selectedParticipants;

  @override
  void initState() {
    super.initState();
    _firstDate = widget.firstDate;
    _lastDate = widget.lastDate;
    _selectedDateTime = widget.event.date;
    _titleController = widget.titleController;
    _descController = widget.descController;
    _coachUsers = widget.coachUsers;
    _users = widget.users;
    _selectedOrganizer = widget.selectedOrganizer;
    _selectedParticipants = [...widget.selectedParticipants];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        DatePickerWidget(
          firstDate: _firstDate,
          lastDate: _lastDate,
          selectedDateTime: _selectedDateTime,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              _selectedDateTime = newDateTime;
            });
          },
        ),
        TextField(
          controller: _titleController,
          maxLines: 1,
          style: const TextStyle(color: ColorPalette.secondary),
          decoration: const InputDecoration(
            labelText: 'Title',
            labelStyle: TextStyle(color: ColorPalette.highlight),
          ),
        ),
        TextField(
          controller: _descController,
          maxLines: 5,
          style: const TextStyle(color: ColorPalette.secondary),
          decoration: const InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(color: ColorPalette.highlight),
          ),
        ),
        OrganizerPickerWidget(
          coachUsers: _coachUsers,
          selectedOrganizer: _selectedOrganizer,
          onOrganizerSelected: (UserModel user) {
            setState(() {
              _selectedOrganizer = user;
            });
          },
        ),
        const SizedBox(height: 16),
        ParticipantPickerWidget(
          users: _users,
          selectedParticipants: _selectedParticipants,
          onParticipantsSelected: (List<UserModel> participants) {
            setState(() {
              _selectedParticipants = participants;
            });
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _updateEvent();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Save",
            style: TextStyle(fontSize: 18, color: ColorPalette.primary),
          ),
        ),
      ],
    );
  }

  void _updateEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('Title cannot be empty');
      return;
    }

    List<String> participantsIds = _selectedParticipants
        .map((participant) => participant.getUserId())
        .toList();

    await FirebaseFirestore.instance
        .collection('calendar')
        .doc(widget.event.id)
        .update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDateTime),
      "organizerId": _selectedOrganizer?.getUserId(),
      "participants": participantsIds,
    });

    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
