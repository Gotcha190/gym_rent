import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_rent/models/user_model.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, UserProfile userProfile) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user?.updateDisplayName(userProfile.firstName);

      await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set(
          {
            'firstName': userProfile.firstName,
            'lastName': userProfile.lastName,
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

  Future<void> updateProfile(UserProfile userProfile) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Aktualizacja displayName
        await user.updateDisplayName(userProfile.firstName);

        // Aktualizacja dodatkowych informacji w bazie danych
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'firstName': userProfile.firstName,
          'lastName': userProfile.lastName,
        });

        // Ponowne wczytanie danych użytkownika po aktualizacji
        await user.reload();
        user = _auth.currentUser;
      }
    } catch (e) {
      print("Błąd aktualizacji profilu: $e");
    }
  }
}
