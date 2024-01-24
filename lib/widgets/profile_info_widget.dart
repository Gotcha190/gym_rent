import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/views/authentication/profile_page.dart';
import 'package:sizer/sizer.dart';

Widget buildProfileInfo(UserModel userProfile, userRole) {
  Map<String, dynamic> fieldsNames = ProfilePage.getFieldsNamesByRole(userProfile, userRole);

  return SingleChildScrollView(
    child: Column(
      children: List.generate(
        fieldsNames.length,
            (index) {
          String fieldName = fieldsNames.keys.elementAt(index);
          return Column(
            children: [
              ListTile(
                title: Text(
                  fieldName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: ColorPalette.secondary,
                  ),
                ),
                subtitle: Text(
                  fieldsNames[fieldName]?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: ColorPalette.highlight,
                  ),
                ),
              ),
              const Divider(
                color: ColorPalette.secondary,
                thickness: 1.0,
              ),
            ],
          );
        },
      ),
    ),
  );
}