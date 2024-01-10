import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firestore/user_service.dart';

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
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDateTime;
  late List<UserModel> _coachUsers;
  UserModel? _selectedOrganizer;
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
    _loadCoachUsers();
    _loadSelectedOrganizer();
  }

  Future<void> _loadCoachUsers() async {
    _coachUsers = await UserService.getCoachUsers();
    setState(() {});
    _isLoading = false;
  }

  Future<void> _loadSelectedOrganizer() async {
    if (widget.event.organizerId != null) {
      UserModel? organizer = await UserService.getUserById(widget.event.organizerId!);
      setState(() {
        _selectedOrganizer = organizer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDateTime.toString().substring(0, 16),
                      style: const TextStyle(color: ColorPalette.secondary),
                    ),
                    IconButton(
                      onPressed: _pickDateTime,
                      icon: const Icon(
                        Icons.edit,
                        color: ColorPalette.highlight,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _titleController,
                  maxLines: 1,
                  style: const TextStyle(color: ColorPalette.secondary),
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: ColorPalette.highlight)),
                ),
                TextField(
                  controller: _descController,
                  maxLines: 5,
                  style: const TextStyle(color: ColorPalette.secondary),
                  decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: ColorPalette.highlight)),
                ),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedOrganizer != null
                        ? '${_selectedOrganizer!.firstName} ${_selectedOrganizer!.lastName}'
                        : 'unknown',
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Organizer',
                    labelStyle: TextStyle(color: ColorPalette.highlight),
                    suffixIcon: Icon(
                      Icons.edit,
                      color: ColorPalette.highlight,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            padding: EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Column(
                                children: _coachUsers.map((user) {
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${user.firstName} ${user.lastName}'),
                                        if (_selectedOrganizer != null)
                                          const Icon(Icons.check, color: ColorPalette.highlight),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedOrganizer = user;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateEvent();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Save",
                      style:
                          TextStyle(fontSize: 18, color: ColorPalette.primary)),
                ),
              ],
            ),
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _updateEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('Title cannot be empty');
      return;
    }

    await FirebaseFirestore.instance
        .collection('calendar')
        .doc(widget.event.id)
        .update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDateTime),
      "organizerId" : _selectedOrganizer?.getUserId(),
    });

    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
