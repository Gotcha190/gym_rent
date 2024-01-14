import 'package:flutter/material.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/views/authentication/profile.dart';

void openEditProfileDialog(
    BuildContext context,
    List<TextEditingController> controllers,
    UserModel userProfile,
    Function updateProfile,
    ProfileUpdateNotifier updateNotifier,) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            controllers.length,
            (index) {
              if (index < userProfile.getFieldsNames().length) {
                String fieldName =
                    userProfile.getFieldsNames().keys.elementAt(index);
                return TextField(
                  controller: controllers[index],
                  decoration: InputDecoration(labelText: fieldName),
                );
              } else {
                return Container(); // Or handle differently when index exceeds the available labels
              }
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              updateProfile();
              updateNotifier.notifyUpdate();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}
