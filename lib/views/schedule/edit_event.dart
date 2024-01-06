import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event", style: TextStyle(color: ColorPalette.primary)),
        backgroundColor: ColorPalette.highlight,
      ),
      body: ListView(
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
                icon: const Icon(Icons.edit, color: ColorPalette.highlight,),
              ),
            ],
          ),
          TextField(
            controller: _titleController,
            maxLines: 1,
            style: const TextStyle(color: ColorPalette.secondary),
            decoration: const InputDecoration(labelText: 'title', labelStyle: TextStyle(color: ColorPalette.secondary)),
          ),
          TextField(
            controller: _descController,
            maxLines: 5,
            style: const TextStyle(color: ColorPalette.secondary),
            decoration: const InputDecoration(labelText: 'description', labelStyle: TextStyle(color: ColorPalette.secondary)),
          ),
          ElevatedButton(
            onPressed: () {
              _updateEvent();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Save", style: TextStyle(fontSize: 18, color: ColorPalette.primary)),
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

    await FirebaseFirestore.instance.collection('calendar').doc(widget.event.id).update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDateTime),
    });

    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
