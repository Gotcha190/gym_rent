import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:sizer/sizer.dart';

Widget buildProfileInfo(UserModel userProfile) {
  return SingleChildScrollView(
    child: Column(
      children: List.generate(
        userProfile.getFieldsNames().length,
        (index) {
          String fieldName = userProfile.getFieldsNames().keys.elementAt(index);
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
                  userProfile.getFieldsNames()[fieldName] ?? '',
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
