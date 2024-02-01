import 'package:flutter/material.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firestore/user_service.dart';
import 'package:gym_rent/views/authentication/profile_page.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late List<UserModel> _allUsers;
  List<UserModel> _filteredUsers = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadFirestoreUsers();
  }

  void _loadFirestoreUsers({String? lastDocumentId, String? searchQuery}) async {
    setState(() {
      _loading = true;
    });

    List<UserModel> moreUsers = await UserService.getAllUsers(lastDocumentId: lastDocumentId);

    setState(() {
      _loading = false;
      if (lastDocumentId == null) {
        _allUsers = moreUsers;
      } else {
        // Unikaj powielania się użytkowników
        Set<String> existingUserIds = Set.from(_allUsers.map((user) => user.uid));
        List<UserModel> uniqueUsers = moreUsers.where((user) => !existingUserIds.contains(user.uid)).toList();

        _allUsers.addAll(uniqueUsers);
      }
      _filteredUsers = _allUsers;
    });
  }

  void _filterUsers(String query) async {
    setState(() {
      _loading = true;
    });

    List<UserModel> filteredUsers;

    if (query.isNotEmpty) {
      // Jeśli wpisano zapytanie, wywołaj metodę do wyszukiwania w bazie danych
      filteredUsers = await UserService.getUserByNameOrSurname(query);
    } else {
      // Jeśli zapytanie jest puste, pokaż wszystkich użytkowników
      filteredUsers = List.from(_allUsers);
    }

    setState(() {
      _loading = false;
      _filteredUsers = filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => _filterUsers(query),
              decoration: const InputDecoration(
                hintText: 'Search users...',
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  String? lastDocumentId = _allUsers.isNotEmpty ? _allUsers.last.uid : null;
                  _loadFirestoreUsers(lastDocumentId: lastDocumentId);
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  UserModel user = _filteredUsers[index];
                  return ListTile(
                    title: Text(user
                        .firstName),
                    subtitle: Text(user
                        .lastName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            refresh: _loadFirestoreUsers,
                          ),
                          settings: RouteSettings(
                            arguments: _filteredUsers[index].uid,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
