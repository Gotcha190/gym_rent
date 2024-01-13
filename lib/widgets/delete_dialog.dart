import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';

class DeleteDialog extends StatelessWidget {
  final Event event;

  const DeleteDialog({required this.event});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Event?",
          style: TextStyle(
              color: ColorPalette.secondary)),
      content: const Text(
          "Are you sure you want to delete?",
          style: TextStyle(
              color: ColorPalette.secondary)),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: ColorPalette.secondary,
          ),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: ColorPalette.highlight,
          ),
          child: const Text("Yes"),
        ),
      ],
    );
  }
}