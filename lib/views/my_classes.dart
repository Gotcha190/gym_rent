import 'package:flutter/material.dart';

class MyClasses extends StatelessWidget {
  const MyClasses({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Classes"),
      ),
      body: const Center(
        child: Text("Create this page"),
      ),
    );
  }
}