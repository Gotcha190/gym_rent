import 'package:flutter/material.dart';

class MyClasses extends StatelessWidget {
  const MyClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final String receivedText = ModalRoute.of(context)!.settings.arguments as String;
    final String text = receivedText.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}