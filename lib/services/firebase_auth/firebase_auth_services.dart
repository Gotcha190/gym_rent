import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_rent/models/user_model.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, UserModel userProfile) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user?.updateDisplayName(userProfile.firstName);

      await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set(
          {
            'uid': credential.user?.uid,
            'firstName': userProfile.firstName,
            'lastName': userProfile.lastName,
            'role': userProfile.role,
          });

      return credential.user;
    } catch (e) {
      print("Some error occurred");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some error occurred");
    }
    return null;
  }

  Future<void> updateProfile(UserModel userProfile) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Aktualizacja displayName
        await user.updateDisplayName(userProfile.firstName);

        // Aktualizacja dodatkowych informacji w bazie danych
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'firstName': userProfile.firstName,
          'lastName': userProfile.lastName,
          'role': userProfile.role
        });

        // Ponowne wczytanie danych użytkownika po aktualizacji
        await user.reload();
        user = _auth.currentUser;
      }
    } catch (e) {
      print("Błąd aktualizacji profilu: $e");
    }
  }

  Future<String?> getUserRole() async {
    String? role;

    // Pobierz aktualnego użytkownika
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Pobierz dane użytkownika z Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Sprawdź, czy dokument istnieje
      if (snapshot.exists) {
        role = snapshot.data()?['role'];
      }
    }

    return role;
  }

  Future<String?> getUserName() async {
    String? name;

    // Pobierz aktualnego użytkownika
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Pobierz dane użytkownika z Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Sprawdź, czy dokument istnieje
      if (snapshot.exists) {
        name = snapshot.data()?['firstName'];
      }
    }

    return name;
  }
}
