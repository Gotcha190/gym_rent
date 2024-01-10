import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/events_model.dart';

class EventItem extends StatelessWidget {
  final Event event;
  final Function() onDelete;
  final Function()? onTap;
  final bool canDelete;
  const EventItem({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
    required this.canDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            event.title,
            style: const TextStyle(color: ColorPalette.highlight),
          ),
          subtitle: Text(event.date.toString().substring(0, 16),
              style: const TextStyle(color: ColorPalette.secondary)),
          onTap: onTap,
          trailing: canDelete
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                )
              : null, // Dodajemy warunek, czy wyświetlić przycisk czy nie
        ),
        const Divider(
          color: ColorPalette.secondary,
          thickness: 1.0,
        ),
      ],
    );
  }
}
