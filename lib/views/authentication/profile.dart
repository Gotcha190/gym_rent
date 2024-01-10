import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firebase_auth/firebase_auth_services.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final List<TextEditingController> _controllers = [];
  late UserModel _userProfile;
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  //TODO: Move this!!!
  Future<void> _loadUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? userRole = await _auth.getUserRole();
      print(userRole);
      if (user != null) {
        // Pobieranie informacji o użytkowniku z bazy danych, na przykład Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        // Tworzenie kontrolerów tekstowych i aktualizacja danych w kontrolerach
        if (snapshot.exists) {
          setState(() {
            _userProfile = UserModel.fromMap(snapshot.data() ?? {});
            _controllers.clear();
            for (var field in _userProfile.toMap().keys) {
              _controllers.add(TextEditingController(
                  text: _userProfile.toMap()[field]?.toString() ?? ''));
            }
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Błąd podczas ładowania profilu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorPalette.primary,
      child: Column(
        children: [
          SizedBox(height: 5.h),
          Text(
            "Profile",
            style: TextStyle(fontSize: 25.sp, color: ColorPalette.highlight),
          ),
          SizedBox(height: 2.h),
          _isLoading ? _buildLoadingIndicator() : _buildProfileInfo(),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _openEditProfileDialog,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ColorPalette.highlight),
            ),
            child: Text(
              "Edit Profile",
              style: TextStyle(fontSize: 15.sp, color: ColorPalette.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          _controllers.length,
          (index) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    _getFieldName(index +
                        1), // Możesz dostosować tekst w zależności od danych
                    style: TextStyle(
                        fontSize: 15.sp, color: ColorPalette.secondary),
                  ),
                  subtitle: Text(
                    _controllers[index].text,
                    style: TextStyle(
                        fontSize: 18.sp, color: ColorPalette.highlight),
                  ),
                  // tileColor: ColorPalette.secondary,
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

  Widget _buildLoadingIndicator() {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _openEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _controllers.length,
              (index) {
                return TextField(
                  controller: _controllers[index],
                  decoration:
                      InputDecoration(labelText: _getFieldName(index + 1)),
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateProfile();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _updateProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Aktualizacja danych w bazie danych, na przykład Firestore
        Map<String, dynamic> updatedData = _userProfile.toMap();
        for (int i = 0; i < _controllers.length; i++) {
          updatedData[updatedData.keys.elementAt(i)] = _controllers[i].text;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updatedData);
        await user.updateDisplayName(_userProfile.firstName);

        // Ponowne wczytanie profilu po aktualizacji
        await _loadUserProfile();
      }
    } catch (e) {
      print("Błąd podczas aktualizacji profilu: $e");
    }
  }

  String _getFieldName(int index) {
    return _userProfile.toMap().keys.elementAt(index - 1);
  }
}
