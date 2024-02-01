import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_rent/models/user_model.dart';
import 'package:gym_rent/services/firebase_auth/firebase_auth_services.dart';
import 'package:gym_rent/services/firestore/user_service.dart';
import 'package:gym_rent/widgets/edit_profile_dialog_widget.dart';
import 'package:gym_rent/widgets/profile_info_widget.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? refresh;
  const ProfilePage({Key? key, this.refresh}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();

  static Map<String, dynamic> getFieldsNamesByRole(
      UserModel userProfile, String? userRole) {
    if (userProfile.role == 'user' && userRole != 'admin') {
      return userProfile.getUserFieldsNames();
    } else if (userProfile.role == 'coach' && userRole != 'admin') {
      return userProfile.getCoachFieldsNames();
    } else if (userProfile.role == 'admin' || userRole == 'admin') {
      return userProfile.getAdminFieldsNames();
    }
    return {};
  }
}

class _ProfilePageState extends State<ProfilePage> {
  late User? _user;
  late UserModel _userProfile;
  late String _userRole;
  late bool _isLoading = true;
  late bool _isUserViewingOwnProfile = true;
  late bool _isAbleToEdit = false;
  final List<TextEditingController> _controllers = [];
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final EditProfileDialog editProfileDialog = EditProfileDialog();

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

  Future<UserModel?> _loadProfile() async {
    var selectedUserUid = ModalRoute.of(context)?.settings.arguments;
    _userRole = (await _auth.getUserRole())!;
    if (selectedUserUid == null) {
      _isUserViewingOwnProfile = true;
      _isAbleToEdit = true;
      return await loadMyProfile();
    } else {
      _isUserViewingOwnProfile = false;
      return await loadOtherProfile(selectedUserUid.toString());
    }
  }

  Future<UserModel?> loadOtherProfile(String userUid) async {
    _userProfile = (await UserService.getUserById(userUid))!;
    await _initializeControllers();
    if (_userRole == 'admin') _isAbleToEdit = true;
    setState(() {
      _isLoading = false;
    });
    return _userProfile;
  }

  Future<UserModel?> loadMyProfile() async {
    _userProfile = (await UserService.getUserById(_user?.uid))!;
    await _initializeControllers();
    setState(() {
      _isLoading = false;
    });
    return _userProfile;
  }

  Future<void> _initializeControllers() async {
    Map<String, dynamic> fieldsNames =
        ProfilePage.getFieldsNamesByRole(_userProfile, _userRole);

    _controllers.clear();
    for (var field in fieldsNames.keys) {
      _controllers.add(
          TextEditingController(text: fieldsNames[field]?.toString() ?? ''));
    }
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
          }
        });
      }
      if (widget.refresh != null) {
        widget.refresh!();
      }
    } catch (e) {
      print("Error $e");
    }
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isUserViewingOwnProfile
                ? Container()
                : AppBar(title: const Text('Profile Page')),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      buildProfileInfo(_userProfile, _userRole),
                      _isAbleToEdit
                          ? editProfileDialog.showButton(
                              context: context,
                              userProfile: _userProfile,
                              updateProfile: _updateProfile,
                              controllers: _controllers,
                            )
                          : Container(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
