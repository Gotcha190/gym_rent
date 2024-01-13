import 'package:flutter/material.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firestore/user_service.dart';

class Coaches extends StatefulWidget {
  const Coaches({super.key});

  @override
  State<Coaches> createState() => _CoachesState();
}

class _CoachesState extends State<Coaches> {
  late List<UserModel> _coachUsers = [];

  Future<void> _loadCoachUsers() async {
    _coachUsers = await UserService.getCoachUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadCoachUsers();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Coaches"),
      ),
      body: ListView.builder(
        itemCount: _coachUsers.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_coachUsers[index].firstName),
            subtitle: Text(_coachUsers[index].lastName),
          );
        },
      ),
    );
  }
}