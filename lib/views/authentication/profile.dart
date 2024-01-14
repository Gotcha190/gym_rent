import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_rent/constants/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firebase_auth/firebase_auth_services.dart';
import 'package:gym_rent/services/firestore/user_service.dart';
import 'package:gym_rent/widgets/edit_profile_dialog_widget.dart';
import 'package:gym_rent/widgets/profile_info_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class ProfileUpdateNotifier extends ChangeNotifier {
  void notifyUpdate() {
    notifyListeners();
  }
}

class ProfilePage extends StatefulWidget {
  final VoidCallback? refresh;
  const ProfilePage({Key? key, this.refresh}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final ProfileUpdateNotifier _updateNotifier = ProfileUpdateNotifier();
  late User? _user;
  final List<TextEditingController> _controllers = [];
  late UserModel _userProfile;
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfile();
  }

  Future<UserModel?> loadOtherProfile(String userUid) async {
    _userProfile = (await UserService.getUserById(userUid))!;
    return _userProfile;
  }

  Future<UserModel?> loadMyProfile() async {
    if (_user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_user?.uid)
          .get();

      // Tworzenie kontrolerów tekstowych i aktualizacja danych w kontrolerach
      if (snapshot.exists) {
        _userProfile = UserModel.fromMap(snapshot.data() ?? {});
        return _userProfile;
      }
    }
    throw Exception("Error loading profile");
  }

  Future<UserModel?> _loadProfile() async {
    var selectedUserUid = ModalRoute.of(context)?.settings.arguments;
    if (selectedUserUid == null) {
      await loadMyProfile(); // Dodaj await tutaj
    } else {
    await loadOtherProfile(selectedUserUid.toString()); // Dodaj await tutaj
    }

    return _userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: _loadProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print("Error loading profile: ${snapshot.error}");
            return const Center(
              child: Text("Error loading profile"),
            );
          } else {
            _userProfile = snapshot.data!;
            _controllers.clear();
            for (var field in _userProfile.toMap().keys) {
              _controllers.add(TextEditingController(
                  text: _userProfile.toMap()[field]?.toString() ?? ''));
            }
            _isLoading = false;

            bool isUserViewingOwnProfile =
                ModalRoute.of(context)?.settings.arguments != null;

            return Container(
              color: ColorPalette.primary,
              width: 100.w,
              child: ClipRect(
                child: Column(
                  children: [
                    isUserViewingOwnProfile
                        ? AppBar(title: const Text('Profile Page'))
                        : Container(),
                    SizedBox(height: 5.h),
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 25.sp, color: ColorPalette.highlight),
                    ),
                    SizedBox(height: 2.h),
                    ChangeNotifierProvider(
                      create: (context) => ProfileUpdateNotifier(),
                      child: Consumer<ProfileUpdateNotifier>(
                        builder: (context, updateNotifier, child) {
                          return buildProfileInfo(_userProfile);
                        },
                      ),
                    ),
                    SizedBox(height: 3.h),
                    FutureBuilder<String?>(
                      future: _auth.getUserRole(),
                      builder: (context, roleSnapshot) {
                        if (roleSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          String? userRole = roleSnapshot.data;

                          if (userRole == 'admin') {
                            return ElevatedButton(
                              onPressed: _openEditProfile,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ColorPalette.highlight),
                              ),
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                    fontSize: 15.sp, color: ColorPalette.primary),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _openEditProfile() {
    openEditProfileDialog(
        context, _controllers, _userProfile, _updateProfile, _updateNotifier);
  }

  void _updateProfile() async {
    try {
      Map<String, dynamic> updatedData = _userProfile.toMap();
      for (int i = 0; i < _controllers.length; i++) {
        updatedData[updatedData.keys.elementAt(i)] = _controllers[i].text;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userProfile.uid)
          .update(updatedData);

      if (mounted) {
        setState(() {
          _controllers.clear();
          for (var field in _userProfile.toMap().keys) {
            _controllers.add(TextEditingController(
                text: _userProfile.toMap()[field]?.toString() ?? ''));
            print(_userProfile.toMap()[field]?.toString());
          }
        });
      }
      if (widget.refresh != null) {
        widget.refresh!();
      }

      _updateNotifier.notifyUpdate();
    } catch (e) {
      print("Error $e");
    }
    _loadProfile();
  }
}
