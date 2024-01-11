import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/user_model.dart';

class OrganizerPickerWidget extends StatefulWidget {
  final List<UserModel> coachUsers;
  final UserModel? selectedOrganizer;
  final Function(UserModel) onOrganizerSelected;

  OrganizerPickerWidget({
    required this.coachUsers,
    required this.selectedOrganizer,
    required this.onOrganizerSelected,
  });

  @override
  _OrganizerPickerWidgetState createState() => _OrganizerPickerWidgetState();
}

class _OrganizerPickerWidgetState extends State<OrganizerPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(
        text: widget.selectedOrganizer != null
            ? '${widget.selectedOrganizer!.firstName} ${widget.selectedOrganizer!.lastName}'
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
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.coachUsers.map((user) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${user.firstName} ${user.lastName}'),
                            if (widget.selectedOrganizer != null &&
                                user.uid == widget.selectedOrganizer!.uid)
                              const Icon(Icons.check, color: ColorPalette.highlight),
                          ],
                        ),
                        onTap: () {
                          widget.onOrganizerSelected(user);
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
    );
  }
}