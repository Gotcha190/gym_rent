import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AddEvent extends StatefulWidget {
  final DateTime selectedDate;

  const AddEvent({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late DateTime _selectedDate;
  late DateTime _selectedDateTime;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _selectedDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 12, 0); // Domyślnie ustawia na 12:00.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(_selectedDate.toString().substring(0, 10)),
              ),
            ],
          ),
          TimePickerSpinner(
            normalTextStyle: const TextStyle(fontSize: 24, color: ColorPalette.secondary),
            highlightedTextStyle: const TextStyle(fontSize: 24, color: ColorPalette.highlight),
            spacing: 30,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                _selectedDateTime = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  time.hour,
                  time.minute,
                );
              });
            },
          ),
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          ElevatedButton(
            onPressed: () {
              _addEvent();
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

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;

    if (title.isEmpty) {
      print('Title cannot be empty');
      return;
    }

    await FirebaseFirestore.instance.collection('calendar').add({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDateTime),
      "organizerId": _auth.currentUser!.uid
    });

    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
