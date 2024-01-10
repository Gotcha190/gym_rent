import 'package:flutter/material.dart';
import 'package:gym_rent/views/authentication/profile.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: const Column(
        children: [
          Expanded(child: ProfilePage()),
        ],
      ),
    );
  }
}