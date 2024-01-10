import 'package:flutter/material.dart';

class Attendees extends StatelessWidget {
  const Attendees({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendees"),
      ),
      body: const Center(
        child: Text("Create this page"),
      ),
    );
  }
}