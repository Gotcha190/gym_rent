import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/views/authentication/profile.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final String receivedText = ModalRoute.of(context)!.settings.arguments as String;
    final String title = receivedText.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Column(
        children: [
          Expanded(child: ProfilePage()),
        ],
      ),
    );
  }
}