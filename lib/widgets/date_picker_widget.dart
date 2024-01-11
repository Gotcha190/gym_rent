import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDateTime;
  final Function(DateTime) onDateTimeChanged;

  DatePickerWidget({required this.selectedDateTime, required this.onDateTimeChanged, required this.firstDate, required this.lastDate});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _firstDate;
  late DateTime _lastDate;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.selectedDateTime;
    _firstDate = widget.firstDate;
    _lastDate = widget.lastDate;
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: _firstDate,
      lastDate: _lastDate,
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
          widget.onDateTimeChanged(_selectedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}