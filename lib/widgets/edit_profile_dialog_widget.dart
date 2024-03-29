import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:sizer/sizer.dart';
import 'package:gym_rent/constants/color_palette.dart';

class EditProfileDialog {
  Widget showButton({
    required BuildContext context,
    required UserModel userProfile,
    required Function updateProfile,
    required List<TextEditingController> controllers,
  }) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Edit Profile"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                controllers.length,
                    (index) {
                      if (index < userProfile.getAdminFieldsNames().length) {
                        String fieldName =
                        userProfile.getAdminFieldsNames().keys.elementAt(index);

                        // Check if the field is 'role'
                        if (fieldName == 'role') {
                          return DropdownButtonFormField<UserRole>(
                            value: userProfile.parseUserRole(userProfile.role),
                            items: UserRole.values.map((UserRole value) {
                              return DropdownMenuItem<UserRole>(
                                value: value,
                                child: Text(describeEnum(value)),
                              );
                            }).toList(),
                            onChanged: (UserRole? newValue) {
                              if (newValue != null) {
                                controllers[index].text = describeEnum(newValue);
                              }
                            },
                            decoration: InputDecoration(labelText: fieldName),
                          );
                        }  else {
                          return TextField(
                            controller: controllers[index],
                            decoration: InputDecoration(labelText: fieldName),
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  updateProfile();
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorPalette.highlight),
      ),
      child: Text(
        "Edit Profile",
        style: TextStyle(fontSize: 15.sp, color: ColorPalette.primary),
      ),
    );
  }
}