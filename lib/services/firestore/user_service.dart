import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_rent/models/user_model.dart';

class UserService {
  // Metoda do pobierania użytkowników z rola 'user'
  static Future<List<UserModel>> getUsers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error loading users: $e');
      return [];
    }
  }

  // Metoda do pobierania użytkowników z rola 'coach'
  static Future<List<UserModel>> getCoachUsers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'coach')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error loading coach users: $e');
      return [];
    }
  }

  static Future<UserModel?> getUserById(String? uid) async {
    try {
      if (uid == null) {
        // Handle the case where uid is null, e.g., return a default user or null
        return null;
      }
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        // Jeśli dokument istnieje, utwórz UserModel
        return UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      } else {
        // Jeśli dokument nie istnieje, zwróć null lub inny odpowiedni obiekt
        return null;
      }
    } catch (e) {
      // Obsługa błędów, np. brak połączenia z internetem
      print('Error getting user by id: $e');
      return null;
    }
  }
}